class NutritionPlan
  Block = Struct.new(:group, :section, :hours, :mix, :mix_ch, :gel, :gel_ch, keyword_init: true)

  BLOCKS = [
    Block.new(group: "Bloque 1", section: nil, hours: 7, mix: "1/2 Drink Mix 320", mix_ch: 40, gel: "Gel 160", gel_ch: 40),
    Block.new(group: "Bloque 2", section: "A", hours: 4, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 160", gel_ch: 40),
    Block.new(group: "Bloque 2", section: "B", hours: 3, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 100", gel_ch: 25),
    Block.new(group: "Bloque 3", section: "A", hours: 2, mix: "1/2 Drink Mix 320", mix_ch: 40, gel: "Gel 160", gel_ch: 40),
    Block.new(group: "Bloque 3", section: "B", hours: 2, mix: "1/2 Drink Mix 320", mix_ch: 40, gel: "Gel 100 CAF", gel_ch: 25),
    Block.new(group: "Bloque 3", section: "C", hours: 3, mix: "1/2 Drink Mix 320", mix_ch: 40, gel: "Gel 160", gel_ch: 40),
    Block.new(group: "Bloque 4", section: "A", hours: 1, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 100 CAF", gel_ch: 25),
    Block.new(group: "Bloque 4", section: "B", hours: 1, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 160", gel_ch: 40),
    Block.new(group: "Bloque 4", section: "C", hours: 2, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 100", gel_ch: 25),
    Block.new(group: "Bloque 4", section: "D", hours: 1, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 160", gel_ch: 40),
    Block.new(group: "Bloque 4", section: "E", hours: 2, mix: "1/2 Drink Mix 160", mix_ch: 20, gel: "Gel 100", gel_ch: 25)
  ]

  def initialize(start_time: "08:00", hours: 30)
    @start_time = start_time.presence || "08:00"
    @max_hours = hours
  end

  def lines
    schedule.map do |info|
      s = day_time(info[:start])
      e = day_time(info[:start] + info[:hours])
      "BLQ #{info[:name].sub('Bloque ', '')} (#{s}–#{e}) - #{info[:mix]} #{info[:mix_ch]} g CH - #{info[:gel]} #{info[:gel_ch]} g CH"
    end
  end

  def pdf
    require "prawn"
    Prawn::Document.new(page_size: 'A4') do |pdf|
      lines.each { |l| pdf.text(l) }
    end.render
  end

  private

  def schedule
    return @schedule if @schedule
    @schedule = []
    count = 0
    BLOCKS.each do |b|
      limit = [b.hours, @max_hours - count].min
      break if limit <= 0
      @schedule << { name: [b.group, b.section].compact.join(' '), start: count, hours: limit, mix: b.mix, mix_ch: b.mix_ch, gel: b.gel, gel_ch: b.gel_ch }
      count += limit
    end
    last = BLOCKS.last
    while count < @max_hours
      if @schedule.empty? || @schedule.last[:name] != [last.group, last.section].compact.join(' ')
        @schedule << { name: [last.group, last.section].compact.join(' '), start: count, hours: 0, mix: last.mix, mix_ch: last.mix_ch, gel: last.gel, gel_ch: last.gel_ch }
      end
      @schedule.last[:hours] += 1
      count += 1
    end
    @schedule
  end

  def day_time(hour_offset)
    h, m = @start_time.split(":").map(&:to_i)
    t = Time.new(2000, 1, 1, h, m) + hour_offset.hours
    t.strftime("%H:%M")
  end
end
