import 'word.dart';

String es(Word word) {
  switch (word) {
    case Word.orders:
      return "Ordenes";
    case Word.spanish:
      return "Español";
    case Word.english:
      return "English";
    case Word.pay_the_bill:
      return "Pagar";
    case Word.call_waiter:
      return "Llamar al mozo";
    case Word.logout:
      return "sair";
    case Word.logout_warning:
      return "Você tem certeza ?";
    case Word.yes:
      return "Sim";
    case Word.pay_now:
      return "Pagar ahora";
    case Word.order_now:
      return "Ordenar ahora";
    case Word.enter_password:
      return "Ingrese su pin";
    case Word.delete:
      return "Eliminar";
    case Word.select_table:
      return "Seleccionar la mesa";
    case Word.table:
      return "Mesa";
    case Word.save:
      return "Guardar";
    case Word.hello:
      return "¡Hola!";
    case Word.welcome:
      return "¡Bienvenido!";
    case Word.swipe_or_tap_for_open_the_menu:
      return "Deslice o toque para abrir el menú";
    case Word.menu:
      return "Menú";
    case Word.there_are_not_available_promotions:
      return "No hay promociones disponibles";
    case Word.categories:
      return "Categorías";
    case Word.empty_category:
      return "Categoría vacía";
    case Word.insert_user_and_password:
      return "Ingrese su correo y contraseña para habilitar este dispositivo";
    case Word.email:
      return "Correo";
    case Word.password:
      return "Contraseña";
    case Word.forgot_password:
      return "Olvidé mi contraseña";
    case Word.enter:
      return "Ingresar";
    case Word.incorrect_user_or_password:
      return "Usuario o contraseña inválida";
    case Word.connection_error:
      return "Error de connecciónde";
    case Word.order_sent:
      return "Orden enviada";
    case Word.order_sent_details:
      return "En breve recibirá su pedido a la mesa";
    case Word.request_receive:
      return "Solicitud recibida";
    case Word.waiter_request_receive_details:
      return "Ya avisamos al Mesero, vendrá en breve";
    case Word.bill_request_receive_details:
      return "Ya avisamos al Mesero que pediste la cuenta";
    case Word.language:
      return "ESP";
    case Word.we_sent_your_order:
      return "Enviamos su plato a Ordenes, no olvide ingresar a Ordenes y \“Ordenar Ahora\” para enviar su orden a la cocina";
    case Word.bar:
      return "Bar";
    case Word.edit:
      return "Editar";
    case Word.delete2:
      return "Borrar";
    case Word.add_to_order:
      return "Agregar a ordenes";
    case Word.edit_ingredients:
      return "Editar ingredientes";
    case Word.no_thanks:
      return "No, gracias";
    case Word.other_drink:
      return "Ver \nmas";
    case Word.accompany_with_drink:
      return "Te gustaría acompañar su pedido con";
    case Word.beer:
      return "Cerveza";
    case Word.cocktail:
      return "Trago";
    case Word.accept:
      return "Aceptar";
    case Word.rate_your_experience:
      return "Califique su experiencia";
    case Word.experience_question:
      return "¿Te pareció una buena experiencia ordenar a traves del iPad?";
    case Word.send:
      return "Enviar";
    case Word.add_edit:
      return "Agregar/Editar";
    case Word.empty_ingredient:
      return "No hay ingredientes para editar";
    case Word.update_order:
      return "Actualizar orden";
    case Word.added_to_orders:
      return "Tu pedido fue enviado a Ordenes";
    case Word.added_tp_orders_details:
      return """Completa tu pedido ingresando a "Ordenes" (Barra lateral izquierda) y clic en "Ordenar ahora\"""";
    case Word.thanks:
      return "Gracias";
    case Word.calling_waiter:
      return "Llamando al Mesero";
    case Word.calling_waiter_details:
      return "El Mesero acudirá pronto a su llamado.";
    case Word.pay_the_bill_details:
      return "Procesando solicitud";
    case Word.error_clients_dont_found:
      return "Error, no se encontró ningun cliente en el servidor";
    case Word.select_your_local:
      return "Seleccione su local";
    case Word.promotions:
      return "Promociones";
    case Word.view_all:
      return "Ver todo";
    case Word.ad:
      return "Publicidad";
    case Word.empty_notifications:
      return "No hay notificaciones";
    case Word.takeaw:
      return "Para llevar";
    case Word.ad_click:
      return "Gracias por dar click, en la publicidad";
    case Word.frase1:
      return "¡Me haces consquillas!";
    case Word.frase2:
      return "¿Te gusto?";
    case Word.frase3:
      return "Ven siempre a este lugar";
    case Word.select_your_preffer_option:
      return "Seleccione su opción preferida,\npor favor";
  }
  return "SYSTEM ERROR";
}
