module EnergysHelper

  #適正タンパク質量
  def protein_amounts
    if current_user.exercise == "everytime" && current_user.gender == "man"
      (current_user.weight*1.2).round(0)
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      (current_user.weight*1).round(0)
    elsif current_user.exercise == "donot" && current_user.gender == "man"
      (current_user.weight*1).round(0)
    elsif current_user.exercise == "everytime" && current_user.gender == "woman"
      (current_user.weight*1.2).round(0)
    else
      50
    end
  end

  #適正カロリー量
  def kcal_amounts
    if current_user.exercise == "everytime" && current_user.gender == "man" 
      2400
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      2200
    elsif current_user.exercise == "donot" && current_user.gender == "man"
      2000
    elsif current_user.exercise == "everytime" && current_user.gender == "woman" 
      2000
    elsif current_user.exercise == "Sometimes" && current_user.gender == "woman"
      1800
    else
      1600
    end
  end

  #適正糖質量
  def sugar_amounts
    if current_user.exercise == "everytime" && current_user.gender == "man"
      210
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      180
    elsif current_user.exercise == "donot" && current_user.gender== "man"
      150
    elsif current_user.exercise == "everytime" && current_user.gender == "woman"
      190
    elsif current_user.exercise == "Sometimes" && current_user.gender == "woman"
      160
    elsif current_user.exercise == "donot" && current_user.gender == "woman"
      130
    end
  end
end