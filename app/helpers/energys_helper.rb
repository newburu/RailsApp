module EnergysHelper
  def protein_amounts
    if current_user.exercise== "everytime"
      (current_user.weight*1.2).round(0)
    else
      (current_user.weight*1).round(0)
    end
  end

  def protein_amounts#女性
    if current_user.exercise == "everytime"
      (current_user.weight*1.2).round(0)
    else
      50
    end
  end
end