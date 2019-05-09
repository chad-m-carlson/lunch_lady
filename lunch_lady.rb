require "pry"
require "colorize"

class MainDish
  attr_accessor :name, :price, :nutrition

  def initialize(name, price, nutrition)
    @name = name
    @price = price
    @nutrition = nutrition
  end
end

class SideDish
  attr_accessor :name, :price, :nutrition

  def initialize(name, price, nutrition)
    @name = name
    @price = price
    @nutrition = nutrition
  end
end

class Person
  attr_accessor :id, :money

  def initialize(id, money)
    @id = id
    @money = money
  end
end

class LunchLady
  attr_accessor :mains, :sides

  def initialize
    @cart = []
    puts "Enter your 4 digit prison ID" #CHANGE TO MORE DIGITS
    id = gets.strip
    random_money = rand(10.0..20).round(2)
    puts "#{id}, You have $#{random_money} available for the Prison Cafetira"
    @mains = [
      MainDish.new("Pigs Tail", 4.50, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
      MainDish.new("Chicken Feet", 4.24, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
      MainDish.new("Liver", 9.73, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
    ]
    @sides = [
      SideDish.new("chips", 0.50, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
      SideDish.new("Baked beans", 2.00, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
      SideDish.new("bread", 0.25, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
      SideDish.new("cabbage", 0.12, { calories: rand(100..400), fat: rand(5..20), protein: rand(10..20), carbs: rand(1..30) }),
    ]
    @person = Person.new(id, random_money)
    pause
    menu
  end

  def menu
    puts "Welcome to the Fulsom Prison Cafeteria"
    puts "Please make a selection..."
    puts "1) View Today's Main Dishes"
    puts "2) View Today's Side Dishes"
    puts "3) View how much money you have"
    puts "4) Make an order"
    puts "5) Review your selections and purchase"
    puts "6) Exit"
    prompt
    menu_selection = gets.to_i
    user_selection(menu_selection)
    pause
  end

  def user_selection(user_input)
    case user_input
    when 1
      clear
      print_mains
    when 2
      clear
      print_sides
    when 3
      clear
      pause
      puts "You have $#{@person.money.round(3)}"
      pause
      menu
    when 4
      clear
      pause
      make_a_maindish_order
    when 5
      clear
      pause
      view_selections
    when 6
      clear
      exit
    else
      puts "Enter a valid choice"
      pause 
      menu
    end
  end

  #HAD THE MAIN MENU PRINTING EVERYTIME I RAN PRINT_MENU SO USED THESE TWO
  def print_mains
    print_menu(mains)
    pause 
    menu
  end

  def print_sides
    print_menu(sides)
    pause 
    menu
  end

  def print_menu(input)
    if input == mains
      puts "Todays Main Dishes"
      @mains.each.with_index do |item, i|
        puts "#{i + 1}) #{@mains[i].name}   $#{@mains[i].price}"
      end
    elsif input == sides
      puts "Todays Side Dishes"
      @sides.each.with_index do |item, i|
        puts "#{i + 1}) #{@sides[i].name}   $#{@sides[i].price}"
      end
    end
    pause
  end

  def wallet
  end

  def make_a_maindish_order
    puts "Please select a main dish, enter '0' if you do not want a main dish"
    print_menu(mains)
    prompt
    main_dish_order = gets.to_i
    main_dish_order == 0 ? make_a_sidedish_order :

      @cart << @mains[main_dish_order - 1]
    puts "That selection has #{@mains[main_dish_order - 1].nutrition[:calories]} calories, #{@mains[main_dish_order - 1].nutrition[:fat]} fat and #{@mains[main_dish_order - 1].nutrition[:carbs]} carbs."
    pause
    puts "Would you like another main dish?"
    print "Y/N> "
    continue = gets.strip.upcase
    if continue == "Y"
      make_a_maindish_order
      pause
    elsif continue == "N"
      make_a_sidedish_order
      pause
    end
    # menu
  end

  def make_a_sidedish_order
    puts "Please select a side dish, enter '0' if you do not want a side dish"
    print_menu(sides)
    prompt
    side_dish_order = gets.to_i
    side_dish_order == 0 ? menu :
      @cart << @sides[side_dish_order - 1]
    puts "That selection has #{@sides[side_dish_order - 1].nutrition[:calories]} calories, #{@sides[side_dish_order - 1].nutrition[:fat]} fat and #{@sides[side_dish_order - 1].nutrition[:carbs]} carbs."
    pause
    puts "Would you like another side dish?"
    print "Y/N> "
    continue = gets.strip.upcase
    if continue == "Y"
      make_a_sidedish_order
      pause
    elsif continue == "N"
      # binding.pry
      pause
      menu
    end
  end

  def view_selections
    puts "You have selected:"
    @cart.each.with_index do |name, i|
      puts "#{@cart[i].name}"
    end
    cost = []
    @cart.each.with_index do |item, i|
      cost << @cart[i].price
    end
    puts "With a total cost of: $#{cost.sum}"
    pause
    if cost.sum > @person.money
      puts "You do not have enough money to purchase all of these items, you only have #{@person.money} available"
      pause
      remove_item
    else
      puts "Would you like to make this purchase?"
      print "Y/N >"
      answer = gets.strip.upcase
      if answer == "Y"
        purchase
      elsif answer == "N"
        puts "Would you like to:"
        puts "1) Remove an item?"
        puts "2) Add more items?"
        puts "3) I don't want any of this garbage"
        answer2 = gets.to_i
        case answer2
        when 1
          remove_item
        when 2
          make_a_maindish_order
          pause
        when 3
          @cart = []
          puts "Your tray is empty"
          pause
          menu
        end
      end
    end
  end

  def purchase
    cost = []
    @cart.each.with_index do |item, i|
      cost << @cart[i].price
    end
    puts "The total cost is #{cost.sum} and will be deducted from your commissary money. You now have #{@person.money - cost.sum}"
    @person.money -= cost.sum
    @cart = []
    pause 
    menu
  end

  def remove_item
    puts "Please select an item to remove from your cart"
    @cart.each.with_index do |items, i|
      puts "#{i + 1})#{@cart[i].name}........$#{@cart[i].price}"
    end
    prompt
    removed = gets.to_i - 1
    puts "#{@cart[removed].name} Has been removed"
    @cart.delete_at(removed)
    puts "Would you like to remove anything else?"
    print "Y/N >"
    response = gets.strip.upcase
    if response == "Y"
      remove_item
    else
      pause
      menu
    end
    pause
    menu
  end
end

def prompt
  print "> "
end

def clear
  print `clear`
end

def pause
  arr = [".....", "......", "..........."]
  arr.each do |i|
    print i
  sleep(0.75)
  end
  puts
end

LunchLady.new

