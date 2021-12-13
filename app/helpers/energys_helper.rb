module EnergysHelper
  def today_protein
    @energys.each do |energy|
      energy.protein
    end
  end
end