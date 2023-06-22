    function parsegapentry(val, index) {
      if (index == 0)
          return parseInt(val, 10);
      else if (index == 1)
        if (val == '1')
          return true;
        else
          return false;
      else if (index > 3 && index < 5)
        return val
      else if (index == 6)
        return parseInt(val, 10)
      else if (index == 7)
        return parseFloat(val, 10)
      else if (index == 8)
        return parseInt(val, 10)
      else
        return val;
    };

    function getname(abbrev) {
      var name = creditsarray.findIndex(function(credit) {
        return credit[0] == abbrev;
      });
      return creditsarray[name][3];
    }

    function get_truncated_primestartstring(p) {
      return p.length > 80 ? p.slice(0, 20) + "..." + p.slice(p.length - 20, p.length) : p
    }

    function get_primestring(r) {
      var c = r[4].toLowerCase();
      var str = r[8] + ' = ' + get_truncated_primestartstring(r[9])
      var label = (c == 'c') ? 'P' : (c == 'p' || c == 'd') ? 'PRP' : (c == 't') ? '(unchecked from trusted discoverer) ' : '??? ';
      return label + str;
    }

    function get_CSV_parse_ready(func) {
      // get_CSV_parse_ready(function(creditsarray, gapsentries) {
      $.when(
          $.get("https://raw.githubusercontent.com/primegap-list-project/primegap-list-project.github.io/master/_data/credits.csv"),
          $.get("https://raw.githubusercontent.com/primegap-list-project/primegap-list-project.github.io/master/_data/allgaps.csv")
      ).then(function(creditscsv, gapscsv) {
        //creditsarray = $.csv.toArrays(creditscsv[0]);
        //gapsarray = $.csv.toArrays(gapscsv[0]);

        var creditsarray = Papa.parse(creditscsv[0]);
        var gapsarray = Papa.parse(gapscsv[0]);

        var gapsentries = gapsarray.data.map(function(entry) {
            return entry.map(parsegapentry)
          });

        func(creditsarray.data, gapsentries);
      });
    }
