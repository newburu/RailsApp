module EnergysHelper

  #適正タンパク質量
  def protein_amounts
    if current_user.exercise== "everytime" && current_user.gender == "man"
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
      2600
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      2400
    elsif current_user.execire == "donot" && current_user.gender == "man"
      2200
    elsif current_user.exercise == "everytime" && current_user.gender == "woman" 
      2200
    elsif current_user.exercise == "Sometimes" && current_user.gender == "woman"
      2000
    else
      1800
    end
  end

  #適正糖質量
  def sugar_amounts
    if current_user.exercise == "everytime" && current_user.gender == "man"
      390
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      360
    elsif current_user.exercise == "donot" && current_user.gender== "man"
      330
    elsif current_user.exercise == "everytime" && current_user.gender == "woman"
      330
    elsif current_user.exercise == "Sometimes" && current_user.gender == "woman"
      300
    elsif current_user.exercise == "donot" && current_user.gender == "woman"
      270
    end
  end
end