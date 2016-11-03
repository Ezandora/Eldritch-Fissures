//This script is in the public domain.
string version = "1.0.9";

boolean setting_ignore_tatter_problem = false;


void preAdventure()
{
	restore_hp(0);
	restore_mp(0);
	cli_execute("mood execute");
	string pre_adventure_script = get_property("betweenBattleScript");
	if (pre_adventure_script != "")
		cli_execute(pre_adventure_script);
}

void postAdventure()
{
	string post_adventure_script = get_property("afterAdventureScript");
	if (post_adventure_script != "")
		cli_execute(post_adventure_script);
}

void main(int turns_to_spend)
{
	boolean should_throw_item = false;
	item throwing_item = $item[flaregun];
	if (throwing_item.item_amount() > 0 && false) //disabled, because currently unimplemented
	{
		boolean yes = user_confirm("Should we throw flareguns? (until the council reward)");
	}
	int starting_turncount = my_turncount();
	print_html("Eldritch Fissures version " + version);
	int last_adventures = my_adventures();
	int limit = 1000;
	item science_notebook = "science notebook".to_item();
	if (science_notebook != $item[none] && science_notebook.available_amount() > 0)
	{
		cli_execute("equip science notebook");
	}
	while (my_adventures() > 0 && limit > 0 && my_turncount() < starting_turncount + turns_to_spend)
	{
		limit -= 1;
		foreach s in $strings[place.php?whichplace=town&action=town_eincursion,place.php?whichplace=town_wrong&action=townrwong_eincursion,place.php?whichplace=plains&action=plains_eincursion,place.php?whichplace=desertbeach&action=db_eincursion]
		{
			int limit2 = 100;
			while (limit2 > 0 && my_turncount() < starting_turncount + turns_to_spend) //fissures stay open for a while
			{
				limit2 -= 1;
				int last_adventures_2 = my_adventures();
				preAdventure();
				buffer page_text = visit_url(s);
				if (should_throw_item && throwing_item.item_amount() > 0 && get_auto_attack() == 0)
					throw_item(throwing_item);
				run_combat();
				if (page_text.contains_text("Eldritch Tentacle"))
					postAdventure();
				else if (last_adventures_2 == my_adventures())
					break;
			}
		}
		if (last_adventures == my_adventures() && !setting_ignore_tatter_problem)
			break;
		last_adventures = my_adventures();
	}
}