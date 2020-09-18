class Period < ApplicationRecord

    BIMESTER = 1
    QUARTER = 2

    def self.get_periods(t_period, t_year, quantity, period_type)
      step = 1
      periods = []
      periods << {:period => t_period, :year => t_year}

      1.upto(quantity - 1) do
        t_period -= step

        if t_period == 0
          t_period = get_period(period_type)
          t_year -= 1
        end

        periods << {:period => t_period, :year => t_year}
      end

      return periods
    end

    def self.get_between_periods(f_period, f_year, t_period, t_year, period_type)
      quantity = get_distance_between_periods(f_period, f_year, t_period, t_year, period_type)
      return get_periods(t_period, t_year, quantity, period_type)
    end

    def self.get_distance_between_periods(f_period, f_year, t_period, t_year, period_type)
      #periods in the same year
      if f_year == t_year
        distance = (t_period - f_period) + 1
        #periods between years
      else
        distance = ((t_year  - f_year) * get_period(period_type)) + (t_period - f_period) + 1
      end

      distance
    end

    def self.build_quarter(quarter, year)
      qdate = ""

      case quarter
      when "1"
        qdate = Time.local(year,1,1)
      when "2"
        qdate = Time.local(year,4,1)
      when "3"
        qdate = Time.local(year,7,1)
      when "4"
        qdate = Time.local(year,10,1)
      end

      return qdate
    end

    def self.get_period(period_type)
      case period_type
      when BIMESTER
        periods_by_year = (12 / 2)
      when QUARTER
        periods_by_year = (12 / 3)
      end

      periods_by_year
    end

    def self.build_ranges_by_average(avg, stddev)
      ranges = []

      jump = ((stddev * 40)/100).round(1)

      from = avg - (jump * 2)
      to = from + jump

      ranges << {:from => from.round(), :to => to.round()}

      1.upto(4) do
        from = to
        to = from + jump
        ranges << {:from => from.round(), :to => to.round()}
      end

      return ranges
    end

    def self.parse_period_to_string(value, period_type)
      per = value.split("/")
      period = per[0]
      year = per[1]

      period_string = period + " " + I18n.translate(period_type) + " 20" + year
      return period_string
    end

    def self.get_period_current(layer_type)
      case layer_type
        when 'future_projects_info'
          @last_period = FutureProject.get_last_period
        when 'transactions_info'
          @last_period = Transaction.get_last_period
        when 'projects_feature_info'
          @last_period = ProjectInstance.get_last_period
        end
    @last_period
    end
  end
