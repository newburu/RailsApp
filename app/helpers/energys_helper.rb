module EnergysHelper

  #男性のタンパク質
  def protein_amounts
    if current_user.exercise== "everytime"
      (current_user.weight*1.2).round(0)
    else
      (current_user.weight*1).round(0)
    end
  end

  #男性のカロリー
  def kcal_amounts
    if current_user.exercise == "everytime" && current_user.gender == "man" 
      2600
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      2400
    elsif current_user.execire == "donot" && current_user.gender == "man"
      2200
    end
  end

  #男性の糖質
  def my_sugar
    if current_user.exercise == "everytime" && current_user.gender == "man"
      390
    elsif current_user.exercise == "Sometimes" && current_user.gender == "man"
      360
    else current_user.exercise == "donot" && current_user.gender== "man"
      330
    end
  end

  #女性のタンパク質
  def protein_amounts
    if current_user.exercise == "everytime"
      (current_user.weight*1.2).round(0)
    else
      50
    end
  end

  #女性の糖質
  def my_sugar
    if current_user.exercise == "everytime" && current_user.gender == "woman"
      330
    elsif current_user.exercise == "Sometimes" && current_user.gender == "woman"
      300
    else current_user.exercise == "donot" && current_user.gender== "woman"
      270
    end
  end

  #女性のカロリー
  def kcal_amounts
    if current_user.exercise == "everytime" && current_user.gender == "woman" 
      2200
    elsif current_user.exercise == "Sometimes" && current_user.gender == "woman"
      2000
    elsif current_user.execire == "donot" && current_user.gender == "woman"
      1800
    end
  end

end