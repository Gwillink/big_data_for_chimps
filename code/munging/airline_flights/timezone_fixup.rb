require 'date'
require 'gorillib/hash/zip'

class Airport

  class TimezoneFixup

    YEARS = (2010 .. 2012).to_a

    DST_RULES = {
      'E' => { name: 'European',       beg_doy: 'last Sunday in March',       end_doy: 'last Sunday in October',                  beg_dates: {}, end_dates: {}, used_in: 'all European countries (except Iceland), as well as Greenland, Lebanon, Russia and Tunisia. Jordan and Syria are almost the same, starting and ending on Friday instead of Sunday. European DST is also used to (crudely) approximate Iranian DST, although they actually use an entirely different calendar.', },
      'A' => { name: 'US/Canada',      beg_doy: '2nd  Sunday in March',       end_doy: '1st  Sunday in November',                 beg_dates: {}, end_dates: {}, used_in: 'the United States (except Arizona, Hawaii and island territories) and Canada (with convoluted exceptions).', },
      'S' => { name: 'South American', beg_doy: '3rd  Sunday in March',       end_doy: '3rd  Sunday in October',     southern: true, beg_dates: {}, end_dates: {}, used_in: 'With some variance in the exact dates, in Argentina, Chile, Mexico, Paraguay, Uruguay as well as the African states of Namibia and Mauritius.', },
      'O' => { name: 'Australia',      beg_doy: '1st  Sunday in April',       end_doy: '1st  Sunday in October',     southern: true, beg_dates: {}, end_dates: {}, used_in: 'Australia, except for Queensland and the Northern Territory.' },
      'Z' => { name: 'New Zealand',    beg_doy: '1st  Sunday in April',       end_doy: 'last Sunday in September',   southern: true, beg_dates: {}, end_dates: {}, used_in: 'New Zealand', },
      'N' => { name: 'None',           beg_doy: nil,                          end_doy: nil,                                       beg_dates: {}, end_dates: {}, used_in: 'DST not observed.', },
      'U' => { name: 'Unknown',        beg_doy: nil,                          end_doy: nil,                                       beg_dates: {}, end_dates: {}, used_in: 'DST status not known. The same as "None".', },
    }

    DST_RULES['E'][:beg_dates] = { 1987 => "1987-03-29", 1988 => "1988-03-27", 1989 => "1989-03-26", 1990 => "1990-03-25", 1991 => "1991-03-31", 1992 => "1992-03-29", 1993 => "1993-03-28", 1994 => "1994-03-27", 1995 => "1995-03-26", 1996 => "1996-03-31", 1997 => "1997-03-30", 1998 => "1998-03-29", 1999 => "1999-03-28", 2000 => "2000-03-26", 2001 => "2001-03-25", 2002 => "2002-03-31", 2003 => "2003-03-30", 2004 => "2004-03-28", 2005 => "2005-03-27", 2006 => "2006-03-26", 2007 => "2007-03-25", 2008 => "2008-03-30", 2009 => "2009-03-29", 2010 => "2010-03-28", 2011 => "2011-03-27", 2012 => "2012-03-25", 2013 => "2013-03-31", 2014 => "2014-03-30", 2015 => "2015-03-29", 2016 => "2016-03-27", 2017 => "2017-03-26", 2018 => "2018-03-25", 2019 => "2019-03-31", 2020 => "2020-03-29", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['E'][:end_dates] = { 1987 => "1987-10-25", 1988 => "1988-10-30", 1989 => "1989-10-29", 1990 => "1990-10-28", 1991 => "1991-10-27", 1992 => "1992-10-25", 1993 => "1993-10-31", 1994 => "1994-10-30", 1995 => "1995-10-29", 1996 => "1996-10-27", 1997 => "1997-10-26", 1998 => "1998-10-25", 1999 => "1999-10-31", 2000 => "2000-10-29", 2001 => "2001-10-28", 2002 => "2002-10-27", 2003 => "2003-10-26", 2004 => "2004-10-31", 2005 => "2005-10-30", 2006 => "2006-10-29", 2007 => "2007-10-28", 2008 => "2008-10-26", 2009 => "2009-10-25", 2010 => "2010-10-31", 2011 => "2011-10-30", 2012 => "2012-10-28", 2013 => "2013-10-27", 2014 => "2014-10-26", 2015 => "2015-10-25", 2016 => "2016-10-30", 2017 => "2017-10-29", 2018 => "2018-10-28", 2019 => "2019-10-27", 2020 => "2020-10-25", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['A'][:beg_dates] = { 1987 => "1987-03-08", 1988 => "1988-03-13", 1989 => "1989-03-12", 1990 => "1990-03-11", 1991 => "1991-03-10", 1992 => "1992-03-08", 1993 => "1993-03-14", 1994 => "1994-03-13", 1995 => "1995-03-12", 1996 => "1996-03-10", 1997 => "1997-03-09", 1998 => "1998-03-08", 1999 => "1999-03-14", 2000 => "2000-03-12", 2001 => "2001-03-11", 2002 => "2002-03-10", 2003 => "2003-03-09", 2004 => "2004-03-14", 2005 => "2005-03-13", 2006 => "2006-03-12", 2007 => "2007-03-11", 2008 => "2008-03-09", 2009 => "2009-03-08", 2010 => "2010-03-14", 2011 => "2011-03-13", 2012 => "2012-03-11", 2013 => "2013-03-10", 2014 => "2014-03-09", 2015 => "2015-03-08", 2016 => "2016-03-13", 2017 => "2017-03-12", 2018 => "2018-03-11", 2019 => "2019-03-10", 2020 => "2020-03-08", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['A'][:end_dates] = { 1987 => "1987-11-01", 1988 => "1988-11-06", 1989 => "1989-11-05", 1990 => "1990-11-04", 1991 => "1991-11-03", 1992 => "1992-11-01", 1993 => "1993-11-07", 1994 => "1994-11-06", 1995 => "1995-11-05", 1996 => "1996-11-03", 1997 => "1997-11-02", 1998 => "1998-11-01", 1999 => "1999-11-07", 2000 => "2000-11-05", 2001 => "2001-11-04", 2002 => "2002-11-03", 2003 => "2003-11-02", 2004 => "2004-11-07", 2005 => "2005-11-06", 2006 => "2006-11-05", 2007 => "2007-11-04", 2008 => "2008-11-02", 2009 => "2009-11-01", 2010 => "2010-11-07", 2011 => "2011-11-06", 2012 => "2012-11-04", 2013 => "2013-11-03", 2014 => "2014-11-02", 2015 => "2015-11-01", 2016 => "2016-11-06", 2017 => "2017-11-05", 2018 => "2018-11-04", 2019 => "2019-11-03", 2020 => "2020-11-01", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['S'][:beg_dates] = { 1987 => "1987-10-18", 1988 => "1988-10-16", 1989 => "1989-10-15", 1990 => "1990-10-21", 1991 => "1991-10-20", 1992 => "1992-10-18", 1993 => "1993-10-17", 1994 => "1994-10-16", 1995 => "1995-10-15", 1996 => "1996-10-20", 1997 => "1997-10-19", 1998 => "1998-10-18", 1999 => "1999-10-17", 2000 => "2000-10-15", 2001 => "2001-10-21", 2002 => "2002-10-20", 2003 => "2003-10-19", 2004 => "2004-10-17", 2005 => "2005-10-16", 2006 => "2006-10-15", 2007 => "2007-10-21", 2008 => "2008-10-19", 2009 => "2009-10-18", 2010 => "2010-10-17", 2011 => "2011-10-16", 2012 => "2012-10-21", 2013 => "2013-10-20", 2014 => "2014-10-19", 2015 => "2015-10-18", 2016 => "2016-10-16", 2017 => "2017-10-15", 2018 => "2018-10-21", 2019 => "2019-10-20", 2020 => "2020-10-18", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['S'][:end_dates] = { 1987 => "1987-03-15", 1988 => "1988-03-20", 1989 => "1989-03-19", 1990 => "1990-03-18", 1991 => "1991-03-17", 1992 => "1992-03-15", 1993 => "1993-03-21", 1994 => "1994-03-20", 1995 => "1995-03-19", 1996 => "1996-03-17", 1997 => "1997-03-16", 1998 => "1998-03-15", 1999 => "1999-03-21", 2000 => "2000-03-19", 2001 => "2001-03-18", 2002 => "2002-03-17", 2003 => "2003-03-16", 2004 => "2004-03-21", 2005 => "2005-03-20", 2006 => "2006-03-19", 2007 => "2007-03-18", 2008 => "2008-03-16", 2009 => "2009-03-15", 2010 => "2010-03-21", 2011 => "2011-03-20", 2012 => "2012-03-18", 2013 => "2013-03-17", 2014 => "2014-03-16", 2015 => "2015-03-15", 2016 => "2016-03-20", 2017 => "2017-03-19", 2018 => "2018-03-18", 2019 => "2019-03-17", 2020 => "2020-03-15", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['O'][:beg_dates] = { 1987 => "1987-10-04", 1988 => "1988-10-02", 1989 => "1989-10-01", 1990 => "1990-10-07", 1991 => "1991-10-06", 1992 => "1992-10-04", 1993 => "1993-10-03", 1994 => "1994-10-02", 1995 => "1995-10-01", 1996 => "1996-10-06", 1997 => "1997-10-05", 1998 => "1998-10-04", 1999 => "1999-10-03", 2000 => "2000-10-01", 2001 => "2001-10-07", 2002 => "2002-10-06", 2003 => "2003-10-05", 2004 => "2004-10-03", 2005 => "2005-10-02", 2006 => "2006-10-01", 2007 => "2007-10-07", 2008 => "2008-10-05", 2009 => "2009-10-04", 2010 => "2010-10-03", 2011 => "2011-10-02", 2012 => "2012-10-07", 2013 => "2013-10-06", 2014 => "2014-10-05", 2015 => "2015-10-04", 2016 => "2016-10-02", 2017 => "2017-10-01", 2018 => "2018-10-07", 2019 => "2019-10-06", 2020 => "2020-10-04", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['O'][:end_dates] = { 1987 => "1987-04-05", 1988 => "1988-04-03", 1989 => "1989-04-02", 1990 => "1990-04-01", 1991 => "1991-04-07", 1992 => "1992-04-05", 1993 => "1993-04-04", 1994 => "1994-04-03", 1995 => "1995-04-02", 1996 => "1996-04-07", 1997 => "1997-04-06", 1998 => "1998-04-05", 1999 => "1999-04-04", 2000 => "2000-04-02", 2001 => "2001-04-01", 2002 => "2002-04-07", 2003 => "2003-04-06", 2004 => "2004-04-04", 2005 => "2005-04-03", 2006 => "2006-04-02", 2007 => "2007-04-01", 2008 => "2008-04-06", 2009 => "2009-04-05", 2010 => "2010-04-04", 2011 => "2011-04-03", 2012 => "2012-04-01", 2013 => "2013-04-07", 2014 => "2014-04-06", 2015 => "2015-04-05", 2016 => "2016-04-03", 2017 => "2017-04-02", 2018 => "2018-04-01", 2019 => "2019-04-07", 2020 => "2020-04-05", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['Z'][:beg_dates] = { 1987 => "1987-09-27", 1988 => "1988-09-25", 1989 => "1989-09-24", 1990 => "1990-09-30", 1991 => "1991-09-29", 1992 => "1992-09-27", 1993 => "1993-09-26", 1994 => "1994-09-25", 1995 => "1995-09-24", 1996 => "1996-09-29", 1997 => "1997-09-28", 1998 => "1998-09-27", 1999 => "1999-09-26", 2000 => "2000-09-24", 2001 => "2001-09-30", 2002 => "2002-09-29", 2003 => "2003-09-28", 2004 => "2004-09-26", 2005 => "2005-09-25", 2006 => "2006-09-24", 2007 => "2007-09-30", 2008 => "2008-09-28", 2009 => "2009-09-27", 2010 => "2010-09-26", 2011 => "2011-09-25", 2012 => "2012-09-30", 2013 => "2013-09-29", 2014 => "2014-09-28", 2015 => "2015-09-27", 2016 => "2016-09-25", 2017 => "2017-09-24", 2018 => "2018-09-30", 2019 => "2019-09-29", 2020 => "2020-09-27", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }
    DST_RULES['Z'][:end_dates] = { 1987 => "1987-04-05", 1988 => "1988-04-03", 1989 => "1989-04-02", 1990 => "1990-04-01", 1991 => "1991-04-07", 1992 => "1992-04-05", 1993 => "1993-04-04", 1994 => "1994-04-03", 1995 => "1995-04-02", 1996 => "1996-04-07", 1997 => "1997-04-06", 1998 => "1998-04-05", 1999 => "1999-04-04", 2000 => "2000-04-02", 2001 => "2001-04-01", 2002 => "2002-04-07", 2003 => "2003-04-06", 2004 => "2004-04-04", 2005 => "2005-04-03", 2006 => "2006-04-02", 2007 => "2007-04-01", 2008 => "2008-04-06", 2009 => "2009-04-05", 2010 => "2010-04-04", 2011 => "2011-04-03", 2012 => "2012-04-01", 2013 => "2013-04-07", 2014 => "2014-04-06", 2015 => "2015-04-05", 2016 => "2016-04-03", 2017 => "2017-04-02", 2018 => "2018-04-01", 2019 => "2019-04-07", 2020 => "2020-04-05", }.tap{|hsh| hsh.each{|year,date_str| hsh[year] = Date.parse(date_str) } }

    def self.parse_boundary(str, *args)
      require 'chronic'
      rank, weekday, art, month = str.split(/\s+/)
      if rank == 'last'
        val = ['5th', '4th'].map{|wk| Chronic.parse([wk, weekday, art, month].join(' '), *args) }.compact.first
      else
        val = Chronic.parse(str, *args)
      end
      Date.new(val.year, val.month, val.day)
    end

    def self.beg_date(rule, year)
      DST_RULES[rule][:beg_dates][year] ||= parse_boundary(DST_RULES[rule][:beg_doy], now: Time.utc(year, 1, 1))
    end
    def self.end_date(rule, year)
      DST_RULES[rule][:end_dates][year] ||= parse_boundary(DST_RULES[rule][:end_doy], now: Time.utc(year, 1, 1))
    end

    def self.table
      %w[E A S O Z].each{|rule| YEARS.each{|year| beg_date(rule, year) ; end_date(rule, year) } }
      DST_RULES
    end

    def self.dst?(rule, val)
      early = beg_date(rule, val.year)
      late  = end_date(rule, val.year)
      in_range = (val >= early) && (val < late)
      DST_RULES[rule][:southern] ? (not in_range) : in_range
    end

  end
end
