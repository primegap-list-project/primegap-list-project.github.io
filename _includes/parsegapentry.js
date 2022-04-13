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
      return (r[4] == 'C') ? 'P' + r[8] + ' = ' + get_truncated_primestartstring(r[9])
      : (r[4] == 'P') ? 'PRP' + r[8] + ' = ' + get_truncated_primestartstring(r[9])
      : 'Unverified ' + r[8] + ' = ' + get_truncated_primestartstring(r[9]);
    }

