class PreguntaSalvavidas {
  final String imagen;
  final String pregunta;
  final List<String> opciones;
  final int indiceCorrecto;

  PreguntaSalvavidas({
    required this.imagen,
    required this.pregunta,
    required this.opciones,
    required this.indiceCorrecto,
  });
}

final List<PreguntaSalvavidas> preguntasNivel1 = [
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_01.webp',
    pregunta: '¿Qué fracción representa la figura coloreada?',
    opciones: ['1/2', '1/4', '1/3', '3/4'],
    indiceCorrecto: 1,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_02.webp',
    pregunta: '¿Quién ganó la competencia y cuántos puntos obtuvo?',
    opciones: [
      'Paula con 10 puntos',
      'Fernanda con 8 puntos',
      'Maritza con 6 puntos',
      'Paula con 5 puntos'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_03.webp',
    pregunta:
        'Si se necesitan 56 ecoladrillos y son 14 estudiantes, ¿cuántos debe traer cada uno?',
    opciones: [
      '4 ecoladrillos',
      '5 ecoladrillos',
      '3 ecoladrillos',
      '6 ecoladrillos'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_04.webp',
    pregunta:
        '¿Cuántos elementos colocó en los contenedores blanco, verde y negro respectivamente?',
    opciones: [
      'Blanco 5, Verde 6, Negro 4',
      'Blanco 5, Verde 4, Negro 6',
      'Blanco 6, Verde 5, Negro 4',
      'Blanco 4, Verde 6, Negro 5'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_05.webp',
    pregunta:
        'Si reciclan 1kg periódico, 3kg revistas y 5kg plástico, ¿Cuántos kg recolectan a diario?',
    opciones: ['8 kg', '9 kg', '10 kg', '7 kg'],
    indiceCorrecto: 1,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_06.webp',
    pregunta: '¿Cuántos kilogramos de plástico y de vidrio tiene ahora Mario?',
    opciones: [
      '13 kg Plástico, 27 kg Vidrio',
      '27 kg Plástico, 13 kg Vidrio',
      '10 kg Plástico, 20kg Vidrio',
      '15 kg Plástico, 25 kg Vidrio'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_07.webp',
    pregunta:
        'L 5kg, M 10kg, Mi 7kg, J 8kg, V 10kg. ¿Cuál fue el peso total recolectado?',
    opciones: ['40 kg', '35 kg', '45 kg', '30 kg'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_08.webp',
    pregunta:
        'A 300 el kilo, para comprar un balón de 18.000, ¿Cuántos kilos de cartón necesitan?',
    opciones: ['50 kg', '60 kg', '70 kg', '80 kg'],
    indiceCorrecto: 1,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_09.webp',
    pregunta:
        'Si Laura tiene 15 pilas y Samuel 9 pilas, ¿cuántas llevarán al depósito?',
    opciones: ['24 pilas', '25 pilas', '22 pilas', '26 pilas'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_10.webp',
    pregunta:
        'Tienen 120 cajas y en cada una alcanzan 9 botellas. ¿Cuántas han recolectado?',
    opciones: [
      '1080 botellas',
      '1000 botellas',
      '1180 botellas',
      '1280 botellas'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_11.webp',
    pregunta:
        'Cepillo de bambú 7.000, paga con 20.000. ¿Cuánto le dieron de regreso?',
    opciones: ['13.000', '12.000', '14.000', '15.000'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_12.webp',
    pregunta:
        'Desechan 25 kg y la meta es reducir a 10 kg. ¿Cuántos kilos deben dejar de producirse?',
    opciones: ['10 kg', '15 kg', '20 kg', '5 kg'],
    indiceCorrecto: 1,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_13.webp',
    pregunta:
        'Se repartirán 120 botellas entre 30 estudiantes. ¿Cuántas botellas le corresponden a cada uno?',
    opciones: ['4 botellas', '3 botellas', '5 botellas', '6 botellas'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_14.webp',
    pregunta:
        'Demoran 7 min contando 2 contenedores. ¿Cuántos minutos demorarán contando 12 contenedores?',
    opciones: ['42 minutos', '40 minutos', '35 minutos', '45 minutos'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel1_15.webp',
    pregunta: 'Recorrido total 120m, avanzaron 90m. ¿Cuántos metros les falta?',
    opciones: ['30 metros', '20 metros', '40 metros', '50 metros'],
    indiceCorrecto: 0,
  ),
];

final List<PreguntaSalvavidas> preguntasNivel2 = [
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_01.webp',
    pregunta:
        'De 300 kg, 1/4 son orgánicos aprovechables. ¿A qué valor en Kilogramos corresponde?',
    opciones: ['75 kg', '50 kg', '100 kg', '150 kg'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_02.webp',
    pregunta:
        '50kg Orgánicos, 35kg No Aprov, 20kg Aprov. ¿A qué porcentaje corresponde cada uno?',
    opciones: [
      '47.6%, 33.3%, 19%',
      '50%, 30%, 20%',
      '45%, 35%, 20%',
      '40%, 40%, 20%'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_03.webp',
    pregunta:
        '124kg cartón, 78kg latas, 90kg plásticas. ¿A qué porcentaje corresponde cada uno?',
    opciones: [
      '42.4%, 26.7%, 30.8%',
      '40%, 30%, 30%',
      '45%, 25%, 30%',
      '50%, 20%, 30%'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_04.webp',
    pregunta:
        '200kg total. 40% Orgánicos, 25% Aprov, 35% No Aprov. ¿Cuántos kg de cada uno?',
    opciones: [
      '80kg, 50kg, 70kg',
      '70kg, 60kg, 70kg',
      '90kg, 40kg, 70kg',
      '80kg, 40kg, 80kg'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_05.webp',
    pregunta:
        'Tanque 60L. Depositó 25 botellas de 1.5L. ¿Cuántos litros faltan para llenarlo?',
    opciones: ['22.5 L', '20.5 L', '25 L', '30 L'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_06.webp',
    pregunta:
        'Con 50kg hacen 5 mesas al mes. ¿Cuántas mesas elaborará en 3 años?',
    opciones: ['180 mesas', '150 mesas', '200 mesas', '120 mesas'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_07.webp',
    pregunta:
        'Área máx 225 cm2. Base licuadora 14 cm x lado. ¿Puede ser almacenada?',
    opciones: [
      'Sí, ocupa 196 cm2',
      'No, ocupa 256 cm2',
      'Sí, ocupa 150 cm2',
      'No, ocupa 225 cm2'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_08.webp',
    pregunta:
        'Nevera 140cm x 90cm. ¿Cuál es el área mínima en metros cuadrados que necesita?',
    opciones: ['1.26 m2', '1.50 m2', '1.00 m2', '2.00 m2'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_09.webp',
    pregunta:
        '1000 ecoladrillos pesan 50.340 gramos. ¿Cuánto pesan en kilogramos?',
    opciones: ['50.34 kg', '5.034 kg', '503.4 kg', '50 kg'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_10.webp',
    pregunta:
        'Recolecta 9 kg diariamente. ¿Cuántos kilogramos recolectarán en 30 días?',
    opciones: ['270 kg', '250 kg', '300 kg', '280 kg'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_11.webp',
    pregunta:
        'Op1 1L a 8.250. Op2 5L a 30.000. Necesitan 70L. ¿Cuál es la más económica?',
    opciones: [
      'Opción 2, gastan 420.000',
      'Opción 1, gastan 577.500',
      'Opción 2, gastan 450.000',
      'Opción 1, gastan 500.000'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_12.webp',
    pregunta:
        'Cartón a 350 el kg. Balón 25.000, tienen 10.000. ¿Cuántos kg deben conseguir?',
    opciones: ['42.85 kg', '40 kg', '45 kg', '50 kg'],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_13.webp',
    pregunta:
        'Tenía 20kg P y 10kg V. Vendió 7kg P y sumó 17kg V. ¿Cuánto tiene ahora?',
    opciones: [
      '13 kg P, 27 kg V',
      '15 kg P, 25 kg V',
      '10 kg P, 30 kg V',
      '12 kg P, 28 kg V'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_14.webp',
    pregunta:
        'Desechable 3 paquetes de 4.500. Vajilla 48 platos a 150 recargo. ¿Qué es mejor?',
    opciones: [
      'Vajillas 7.200',
      'Desechables 13.500',
      'Desechables 9.000',
      'Vajillas 8.000'
    ],
    indiceCorrecto: 0,
  ),
  PreguntaSalvavidas(
    imagen: 'assets/images/preguntas/tarjeta_nivel2_15.webp',
    pregunta:
        'L5, M10, Mi7, J8, V10. ¿Cuál fue el promedio de peso recolectado?',
    opciones: ['8 kg', '7 kg', '9 kg', '10 kg'],
    indiceCorrecto: 0,
  ),
];
