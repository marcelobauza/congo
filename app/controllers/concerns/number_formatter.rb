module NumberFormatter
 extend ActiveSupport::Concern

		DEFAULT_THOUSAND_SEPARATOR = ".";
		DEFAULT_DECIMALS_SEPARATOR = ","
		LESS_THAN_THOUSAND = 0;
		THOUSAND = 1;
		MILLION = 2;
		WITHOUT_DECIMALS = -1;

		def self.format(number, with_decimals=false)
      number = number.to_f
			decimals = WITHOUT_DECIMALS
			is_negative = false

			if(number < 0)
				number = number * -1;
				is_negative = true;
      end

      decimals_arr = []
			number = Float(number).round(1)
			decimals_arr = number.to_s.split(".")
			decimals = decimals_arr[1].to_f if(with_decimals and decimals_arr.size == 2)

			number_arr = decimals_arr[0].split("")
			number_separator_arr = []
			cont = 0

      number_arr.reverse.each do |n|
				number_separator_arr << n.to_s
				cont += 1

				if cont == 3
					number_separator_arr << DEFAULT_THOUSAND_SEPARATOR
					cont = 0;
        end
      end

			number_separator_arr.pop if(number_separator_arr[0] == DEFAULT_THOUSAND_SEPARATOR)

			is_first = true
			formatted_number = ''

      number_separator_arr.reverse.each do |ns|

				if is_first and ns == DEFAULT_THOUSAND_SEPARATOR
					is_first = false
					next
        end

				if is_negative
					formatted_number += '-'
					is_negative = false
        end

				is_first = false;
				formatted_number += ns
      end

			formatted_number += DEFAULT_DECIMALS_SEPARATOR + decimals_arr[1] if decimals != WITHOUT_DECIMALS

			return formatted_number
    end
    
		def self.abbreviate(number)
			number_without_decimals = Float(number).round(0).to_i;
			is_negative = false;

			if number_without_decimals < 0
				number_without_decimals = number_without_decimals * -1;
				is_negative = true;
      end

			number_arr = number_without_decimals.to_s.split("")
			number_type = LESS_THAN_THOUSAND
			number_arr_copy = number_arr.clone

			if number_arr.length >= 7
				number_type = MILLION
 				i = 0;

				number_arr.each do |n|
					number_arr_copy.pop if i < 6
					i += 1
        end

			elsif number_arr.size >= 4
				number_type = THOUSAND
				j = 0

				number_arr.each do |n|
					number_arr_copy.pop if j < 3
					j += 1
        end
      end

      decimals = 0.0
      decimals = ("0." + number_arr[number_arr_copy.size] + number_arr[number_arr_copy.size + 1]).to_f unless number_arr[number_arr_copy.size].nil? or number_arr[number_arr_copy.size + 1].nil?

			number_str = ''
			number_arr_copy.each { |n| number_str += n.to_s }

			if is_negative
				number = number_str.to_f * -1
			else
				number = number_str.to_f
      end

      number = number + decimals

      if(decimals == 0.0)
        number_str = format(number, false)
      else
        number_str = format(number, true)
      end

			if number_type == MILLION
				number_str += "M";
			elsif number_type == THOUSAND
				number_str += "K";
      end

			return number_str;
   end
end