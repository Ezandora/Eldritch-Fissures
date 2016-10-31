//This script is in the public domain.
string version = "1.0";

void main()
{
	print_html("Eldritch Fissures version " + version);
	int last_adventures = my_adventures();
	while (my_adventures() > 0)
	{
		cli_execute("restore hp");
		cli_execute("mood execute");
		foreach s in $strings[place.php?whichplace=town&action=town_eincursion,place.php?whichplace=town_wrong&action=townrwong_eincursion,place.php?whichplace=plains&action=plains_eincursion,place.php?whichplace=desertbeach&action=db_eincursion]
		{
			while (true) //fissures stay open for a while
			{
				int last_adventures_2 = my_adventures();
				visit_url(s);
				run_combat();
				if (last_adventures_2 == my_adventures())
					break;
			}
		}
		if (last_adventures == my_adventures())
			break;
		last_adventures = my_adventures();
	}
}