import './word.dart';

String en(Word word) {
  switch (word) {
    case Word.orders:
      return "Orders";
    case Word.spanish:
      return "Español";
    case Word.english:
      return "English";
    case Word.pay_the_bill:
      return "Pay";
    case Word.call_waiter:
      return "Call waiter";
    case Word.logout:
      return "Logout";
    case Word.logout_warning:
      return "Are you sure?";
    case Word.yes:
      return "Yes";
    case Word.pay_now:
      return "Pay now";
    case Word.order_now:
      return "Order now";
    case Word.enter_password:
      return "Enter pincode";
    case Word.delete:
      return "Delete";
    case Word.select_table:
      return "Select table";
    case Word.table:
      return "Table";
    case Word.save:
      return "Save";
    case Word.hello:
      return "Hello!";
    case Word.welcome:
      return "Welcome!";
    case Word.swipe_or_tap_for_open_the_menu:
      return "Swipe or tap for open the menu";
    case Word.menu:
      return "Menu";
    case Word.there_are_not_available_promotions:
      return "There are not available promotions";
    case Word.categories:
      return "Categories";
    case Word.empty_category:
      return "Empty category";
    case Word.insert_user_and_password:
      return "Enter your email and password to enable this device";
    case Word.email:
      return "Email";
    case Word.password:
      return "Password";
    case Word.forgot_password:
      return "I forgot password";
    case Word.enter:
      return "Enter";
    case Word.incorrect_user_or_password:
      return "Incorrect user or password";
    case Word.connection_error:
      return "Connection error";
    case Word.order_sent:
      return "Order sent";
    case Word.order_sent_details:
      return "You will receive your order at the table shortly";
    case Word.request_receive:
      return "Request received";
    case Word.waiter_request_receive_details:
      return "We already let the waiter know, he will come soon";
    case Word.bill_request_receive_details:
      return "We already notified the waiter that you asked for the account";
    case Word.language:
      return "ENG";
    case Word.we_sent_your_order:
      return "We send your plate to Orders, do not forget to enter Orders and \"Order Now \" to send your order to the kitchen";
    case Word.bar:
      return "Bar";
    case Word.edit:
      return "Edit";
    case Word.delete2:
      return "Delete";
    case Word.add_to_order:
      return "Add to order";
    case Word.edit_ingredients:
      return "Edit ingredients";
    case Word.no_thanks:
      return "No, thanks";
    case Word.other_drink:
      return "See\n more";
    case Word.accompany_with_drink:
      return "You would like to accompany your order with";
    case Word.beer:
      return "beer";
    case Word.cocktail:
      return "Cocktail";
    case Word.accept:
      return "Accept";
    case Word.rate_your_experience:
      return "Rate your experience";
    case Word.experience_question:
      return "Did you find it a good experience to order through the iPad?";
    case Word.send:
      return "Send";
    case Word.add_edit:
      return "Add/Edit";
    case Word.empty_ingredient:
      return "There are not ingredients for edit";
    case Word.update_order:
      return "Update order";
    case Word.added_to_orders:
      return "Your order was sent to Orders";
    case Word.added_tp_orders_details:
      return """Complete your order by entering "Orders" (Left sidebar) and click "Order now \"""";
    case Word.thanks:
      return "Thanks";
    case Word.calling_waiter:
      return "Calling the Waiter";
    case Word.calling_waiter_details:
      return "The waiter will come to your call soon.";
    case Word.pay_the_bill_details:
      return "Processing request";
    case Word.error_clients_dont_found:
      return "Error, no client was found on the server";
    case Word.select_your_local:
      return "Select your local";
    case Word.promotions:
      return "Promotions";
    case Word.view_all:
      return "View all";
    case Word.ad:
      return "Ad";
    case Word.empty_notifications:
      return "Empty notifications";
    case Word.takeaw:
      return "Takeaw";
    case Word.ad_click:
      return "Thaks you";
    case Word.frase1:
      return "You tickle me!";
    case Word.frase2:
      return "You like me?";
    case Word.frase3:
      return "Always come to this place";
    case Word.select_your_preffer_option:
      return "Select your preferred option, \nplease";
  }
  return "[Word dont found]";
}
