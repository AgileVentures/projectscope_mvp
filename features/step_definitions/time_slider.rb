When /^I slide (\d+) days{0,1} (.*)/ do |num_day, direction|
	num_day = num_day.to_i
	if direction == "backward"
		value = -1 * num_day
	elsif direction == "forward"
		value = num_day
	end
	page.execute_script "s=$('#date-slider')"
	page.execute_script "cur_val=s.slider('option', 'value')"
	page.execute_script "s.slider('option', 'value', cur_val + #{value})"
	page.execute_script "s.slider('option','slide').call(s,null,{ handle: $('.ui-slider-handle', s), value: #{value} });"
end

Then /^"(.*)" should be outdated/ do |metric_id|
	page.find(metric_id)[:class].include? "outdated-metric"
end