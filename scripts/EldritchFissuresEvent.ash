//This script is in the public domain.
string version = "1.0.4";

boolean setting_tatter = false;

void main(int turns_to_spend)
{
	int starting_turncount = my_turncount();
	print_html("Eldritch Fissures version " + version);
	int last_adventures = my_adventures();
	int limit = 1000;
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
				cli_execute("restore hp");
				cli_execute("mood execute");
				buffer page_text = visit_url(s);
				run_combat();
				if (last_adventures_2 == my_adventures())
					break;
			}
		}
		if (last_adventures == my_adventures() && !setting_tatter)
			break;
		last_adventures = my_adventures();
	}
}