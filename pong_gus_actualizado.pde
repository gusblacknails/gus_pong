
// Per aquesta pràctica final he volgut recrear el mític joc del Pong ja que tot i que no és un joc dels més dificils sí que té certes complicacions si es vol aprofundir una mica en cop fer-lo realista.
// Com a codi de base vaig trobar un gist de github que em va servir per fer-me una idea de com començar tot i que realment la part d'aquest que he acabat deixant és bastant simple i l'hagues pogut treure per mi mateix.
// És aquest: 
// https://gist.github.com/dc74089/4094da7928839063ae06

// A més també em vaig inspirar en una pac que vaig fer a Interacció Tangible on apareixia una part de la física que he acabat fent servir. Bàsicament el comportament de la pilota en rebotar contra objectes, límits de pantalla i les raquetes.
// Aquí comparteixo un vídeo de la PAC en questió:
// https://www.youtube.com/watch?v=eN7hkMaO6XE

// El joc té diferents pantalles, un menú d'inici, una pàgina de configuració per escollir les músiques, el nivell, el mode d'un jugador o dos i un parell d'extres que li he afegit.
// El primer extra es un mode d'Obstacles invisibles que es mouen de forma horitzontal per la pantalla i fan que soptadament la pilota canvíi de direcció donant-li una dificultat extra al joc.
// El segon extra és el que he anomenat "mode bojeria" on van canviant els colors de fons i el color de la pilota i on sobretot la pilota té un comportament erratic dificil de predir el que també li dona més dificultat i diversió al joc.

// La resta de pantalles son la pròpia del joc, les pantalles de game over o de guanyador i una última pantalla de sortida del joc.


//Com a observació, la part que més m'ha costat de programar és el funcionament autónom de la màquina ja que arribar a un compromis entre fer una màquina que sempre guanyés i una que sempré perdés m'ha costat molt. Els paràmetres per donar-li un cert error al.leatori m'han costat bastant de trobar i és bastant dificil guanyar-la la majoria de les vegades.
// També m'he trobat amb moltes imprecissions en els rebots de les raquetes ja que hi ha vegades que la pilota sembla que no impacti però sí que rebota. No he acabat de trobar com arreglar aquest comportaments que apareixen de tant en quant.


//Pàgina d'on he tret les músiques de 8 bits que sonen al joc. Totes son lliures de drets
//https://www.fesliyanstudios.com/royalty-free-music/downloads-c/8-bit-music/6
//Pàgina d'on he tret els efectes de so:
//https://pixabay.com/sound-effects/search/point/

//importem les ControlP5 que farem servir pels botons i processing.Sound per a gestionar les músiques i els efectes de so
import controlP5.*;
import processing.sound.*;
//Carreguem la llibreria ControlP5 i li donem el nom de cp5 per quan l'haguem d'instanciar.
ControlP5 cp5;

//Creem una variable PImage on després carregarem la imatge del logo del joc
PImage logo;
//Creem una variable PFont on després carregarem la font que farem servir als textes
PFont fontTextos;

//inicialitzem l'estat per defecte de les variables d'estat 
int musicaActual = 0;
int ultimGuanyador = 1;
int pantalla = 0;
// xequeig per saber si estan apretades o no en cada frame de les tecles de moviment
boolean pujarApretat = false;
boolean baixarApretat = false;
boolean pujarDosApretat = false;
boolean baixarDosApretat = false;
// les dues següents eviten que els botons es pintin més d'una vegada mentre estem a la pantalla
boolean menuInicialitzat = false;
boolean configInicialitzat = false;
//aquesta variable la fa servir la màquina per centrarse i que li doni temps a arribar al següent rebot
boolean tornaAlCentre = false;
// variable per saber si s'ha d'activar el bloc de codi que genera els obstacles invisibles
boolean obstaclesInvisibles = false;
// variable per saber si s'han d'activar els blocs de codi repartits pel programa que son del mode bojeria
boolean modeBojeria = false;
// controla si s'està reproduïnt la música al entrar a la pantalla de gameOver
boolean noSonaMusica = false;
// estat per saber si s'ha de dispara o no la música del joc bans del temps d'espera per a que soni l'efecte d'entrada
boolean esperantMusica = false;
// estat per saber si s'ha de reproduir musica o deixar només els efectes de so
boolean senseMusica = false ;
// aquesta variable permet a la màquina pujar la seva velocitat de reacció en el mode dificil ja que sinó sempre perdia
boolean nivellDificil = false;
// es convertirà en true un cop s'entri a la pantalla d'exit
boolean començaAContar = false;
// permet aplicar el bloc de codi on juga la màquina o el segon jugador
boolean segonJugador = false;
// velocitat inicial de la pilota. Per defecte està en el nivell intermedi
// necessitem dues velocitats ja que el signe positiu o negatiu del multiplicador que aplicarem en xocar contra les cantonades, obtacles o raquetes marcarà la direcció. 
//Si tansols tinguessim una velocitat arribaria un moment que l'elipse xocaria contra 
//una cantonada i no podria continuar.
float velocitatX = 7, velocitatY = 7; 
//temps desde l'últim rebot. Ho fem servir per evitar falsos rebots als obstacles invisibles que feien que la pilota fes moviments extranys 
float ultimRebot = 0; 

// temps des de que apretem el botó de jugar per a deixar un petit temps d'espera entre la música d'entrada i la del joc
float tempsIntro; 
// posicio de la pilota a cada frame
float pilotaX, pilotaY; 
// mides de les raquetes
int ampladaRaqueta = 20; 
int allargadaRaqueta = 100;
// variables per la puntuació de cada jugador. Comencen a 0
int punts1 = 0; 
int punts2 = 0;
// limit de punt abans de sortir de  la partida
int limitPunts = 5;
// serà el temps que comparem per saber si han passat els 3 segons abans de sortir del joc
int tempsALaPagina; 
// posició de les raquetes a cada frame
float posicioRaqueta1;
float posicioRaqueta2;
//posició dels obstacles invisibles que es troba la pilota a cada frame
float rect_1_x, rect_1_y, rect_2_x, rect_2_y, rect_3_x, rect_3_y, rect_4_x, rect_4_y, rect_5_x, rect_5_y; 

// inicialitzem les variable que crearan els botons de kla llibreria cp5
Button botoConfig;  
Button botoIniciJoc;
Button botoExit;
Button musica1;
Button musica2;
Button musica3;
Button senseMusiques;
Button facil;
Button intermig;
Button dificil;
Button unJugador;
Button dosJugadors;
Button tornarMenu;
Toggle botoObstaclesInvisibles;
Toggle botoModeBojeria;
// inicialitzem l'array que contindrà les músiques
SoundFile[] musiques = new SoundFile[3];
// iniciaitzem les variables que crearan els efectes de so
SoundFile gameOver, botons, cop, start, victoria, punt;

void setup() {
  // creem el canvas
  size(800, 600);
  // carreguem la font dels textos
  fontTextos = createFont("Arial", 32);
  // la passem a la instància que carrega la font
  textFont(fontTextos);
  // creem una intància de la llibreria controlP5
  cp5 = new ControlP5(this);
  //cridem a la funció que carrega cada música a una posició de l'array
  carregarMusiques();
  // carreguem els efectes de so instanciant un nou soundFile per a cadascun d'ells
  gameOver = new SoundFile(this, "musiques/game_over.mp3");
  botons = new SoundFile(this, "musiques/arcade-ui-botons.mp3");
  cop = new SoundFile(this, "musiques/cop.mp3");
  start = new SoundFile(this, "musiques/gamestart.mp3");
  victoria = new SoundFile(this, "musiques/victory.mp3");
  punt = new SoundFile(this, "musiques/punt.mp3");
  // carreguem la imatge del logo que surt a la pantalla d'inici
  logo = loadImage("imatges/logo_guspong.jpg");

}
void draw() {
  if(modeBojeria){
    // asignem nous valors als canals rgb a cada nou frame per a que el fons vari variant de color. Gràcies al mòdul de 255 aconseguim que els valors no superin el rang de 255 que és el màxim valor permés
    float r = frameCount*4 % 255; 
    float g = (frameCount*4+ 85) % 255;
    float b = (frameCount*8 + 170) % 255;
    // li apliquem els valors al fons
    background(r, g, b);
  
  }else{
    // en mode normal refresquem el fons a cada frame amb color negre
    background(0);
  }
  //si pantalla és 0 entrem al menú principal
  if (pantalla == 0){ 
    // si tornem del menú config amagem els botons de l'anterior pantalla
    if (configInicialitzat){
      amagaBotonsConfig();
      configInicialitzat= false;
      // ens permet tornar a crear els botons del menú d'inici
      menuInicialitzat=false;
      
    }
    //crida a la funció que dibuixa el menú d'inici
    menuInici();
  
  }
  // si pantalla és 1 amaguem els botons del menú d'inici i cridem a la funció que té la lògica del joc
  else if (pantalla == 1) {
    amagaBotonsMenu();
    jugar();
      
  }
  // si pantalla és 2 entrem a la pantalla de gameOver si juguem contra la màquina, si està en mode dos jugadors entrarà a l'equivalent però per dos jugadors
  else if (pantalla == 2){ 
    if(!segonJugador){
      pantallaGameOver(ultimGuanyador , punts1,  punts2);
    } else {
      pantallaGuanyador( ultimGuanyador ,  punts1,  punts2);
    }
    
  }
  // si pantalla és 3 entrem al menú de configuració
  else if (pantalla == 3) {
    menuConfiguració();
    // indica que ja em entrat un cop al menú i evita sobreescriure els botons
    configInicialitzat = true;
  }
  // si pantalla és 4 entrem a la pantalla de sortida
  else if(pantalla==4){
    // amaga els botons del menú d'inici
    amagaBotonsMenu();
    pantallaSortida();
    
  }
   
}
// funció que pinta el menu d'inici
void menuInici() {
  // resetejem el fons a cada frame
  background(0);
  // mode per centrar la imatge
  imageMode(CENTER);
  // coloquem la imatge del logo
  image(logo, width / 2  , 150 , 300, 150);
  // color blanc pel text
  fill(255);
  // text on s'expliquen els controls per jugar
  textAlign(CENTER);
  textSize(18);
  text("Controls:",  width / 2, 470);
  text("Jugador 1 W per pujar i S per baixar", width / 2, 500);
  text("Jugador 2 FLETXA  AMUNT per pujar i FLETXA  ABAIX per baixar", width / 2, 530);
  text("ESPAI per tornar al menú principal", width / 2,560);
  // només entrem en aquest if la primera vegada per evitar sobreescriure els botons a cada frame
  if (!menuInicialitzat){
    
    //creem el botó per entrar al joc, li donem un nom, un label, una posició, tamany i colors per cada estat 
    botoIniciJoc = cp5.addButton("comecarJoc")
    .setLabel("JUGAR")
    .setPosition(320, 250)
    .setSize(160, 40)
    .setColorBackground(color(15, 72, 40))
    .setColorForeground(color(80, 180, 80)) 
    .setColorActive(color(100, 200, 100))
    // lògica per quan s'apreta el botó d'inici del joc
    .onClick((e) -> {
      // cridem a la funció que reseteja els valors de joc i crida a la funció que conté la lógica del joc
      iniciarJoc();
     
      //fem sonar l'efecte d'apretar el botó
      botons.play();
      //parem les músiques
      paraMusiques();
      // efecte d'inici de partida
      start.play();
      // comencem a contar el temps d'espera per a que no es solàpin l'efecte d'inici de partida i la música i posem els estats corresponents
      tempsIntro = millis();
      esperantMusica = true;
      noSonaMusica = false;
      });
    botoConfig = cp5.addButton("obrirConfiguració")
    .setLabel("CONFIGURACIO")
    .setPosition(320, 300)
    .setSize(160, 40)
    .setColorBackground(color(15, 72, 40))
    .setColorForeground(color(80, 180, 80)) 
    .setColorActive(color(100, 200, 100))
    .onClick((e) ->{ 
      // setejem la variable pantalla per a que a la propera passada pel draw() entri al menú de configuració
      pantalla = 3;
      botons.play();});
      //evitem sobreescriure els botons
      menuInicialitzat = true;
    //mateixa lògica
    botoExit = cp5.addButton("SORTIR")
     .setPosition(320, 350)
     .setSize(160, 40)
     .setColorBackground(color(15, 72, 40))
     .setColorForeground(color(80, 180, 80)) 
     .setColorActive(color(100, 200, 100))
     .onClick((e) -> { 
       pantalla = 4;
       botons.play();});
  }
}
//funció que assigna una música a cada entrada de l'array de músiques i fa que un cop carregades es reprodueixi la seleccionada en loop
void carregarMusiques() {
  musiques[0] = new SoundFile(this, "musiques/musica_1.mp3");
  musiques[1] = new SoundFile(this, "musiques/musica_2.mp3");
  musiques[2] = new SoundFile(this, "musiques/musica_3.mp3");
  musiques[0].loop();
}


void menuConfiguració() {
  //fons negre
  background(0);
  //color de text blanc
  fill(255);
  // títols de les seccions de la configuració
  textAlign(CENTER);
  textSize(24);
  text("Configuració", width / 2, 50);
  textSize(20);
  text("Escull la música", 160, 135);
  text("Nivell del joc", width/2, 135);
  text("Jugadors", width - 160, 135);
  text("Extras", width - 160, 260);
  textSize(16);
  text("Obstacles Invisibles", width - 160, 285);
  text("Mode Bojeria", width - 160, 367);
  //evitem crear els botons més d'una vegada
  if (!configInicialitzat){
      // fem remove als botons del menú d'inici
      amagaBotonsMenu();
      // botons per les músiques. A l'onclick cridem a la funcio que gestiona quina musica es selecciona de l'array de músiques
      musica1 = cp5.addButton("musica1")
      .setLabel("Musica 1")
      .setPosition(100, 150)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) -> {canviaMusica(0);
      // fem sonar l'efecte de quan s'apreta un botó
      botons.play();});
      musica2 = cp5.addButton("musica2")
      .setLabel("Musica 2")
      .setPosition(100, 200)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) -> {canviaMusica(1);
      botons.play();});
      musica3 = cp5.addButton("musica3")
      .setLabel("Musica 3")
      .setPosition(100, 250)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) -> {canviaMusica(2);
      botons.play();});
      senseMusiques = cp5.addButton("senseMusiques")
      .setLabel("Sense musica")
      .setPosition(100, 300)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      // cridem a la funció que para les músiques
      .onClick((e) -> {paraMusiques();
      senseMusica = true;
      botons.play();});
      //botons per seleccionar el nivell del joc
      facil = cp5.addButton("nivellFacil")
      .setLabel("Facil")
      .setPosition( width/2 - 60 , 150)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
       .onClick((e) ->{
         //funció que gestiona el nivell del joc, bàsicament la velocitat a la que va la pilota
         canviaNivell(0);
        nivellDificil = false;
        botons.play();});
      intermig = cp5.addButton("nivellIntermedi")
      .setLabel("Intermedi")
      .setPosition( width/2 - 60, 200)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) ->{ canviaNivell(1);
       nivellDificil = false;
       botons.play();});
      dificil = cp5.addButton("nivellDificil")
      .setLabel("Difícil")
      .setPosition( width/2 - 60, 250)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) -> {canviaNivell(2);
       // aquest boolea farà que entri la part del codi que fa que la màquina funcioni diferent en el ode díficil donant-li més velocitat d'actuació
       nivellDificil = true;
       botons.play();});
       // gestionem si volem un o dos jugadors activant o no la part del codi que fa o que juguem contra la màquina o contra un segon jugador
      unJugador = cp5.addButton("unJugador")
      .setLabel("1 Jugador")
      .setPosition( width - 220, 150)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) ->{segonJugador= false;
       botons.play();});
      dosJugadors = cp5.addButton("dosJugadors")
      .setLabel("2 Jugadors")
      .setPosition( width - 220, 200)
      .setSize(120, 30)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) -> { segonJugador= true;
       botons.play();});
       // activem l'extra que fa que apareguin els obstacles invisibles. En aquest cas es un botó toggle que s'activa o es desactiva
      botoObstaclesInvisibles = cp5.addToggle("obstaclesInvisibles")
      .setPosition(width - 220, 300)
      .setSize(120, 30)
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setLabel("Obstacles: OFF")
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80))
      .setColorActive(color(100, 200, 100))
      .onChange((e) -> {
      // aquest boolea fa que el label bojeria passi d'on a off. En apretar el botó l'event canvia de 0 a 1 o el que és el mateix de false a true
      boolean estat = e.getController().getValue() > 0;
      // aquest ternari seria com un if one liner
      String labelObstacles = "Obstacles: " + (estat ? "ON" : "OFF");
      // apliquem el label que ens retorna el ternari
      e.getController().setLabel(labelObstacles);
      botons.play();
      });
      // mateix funcionament que el toggle anterior
      botoModeBojeria = cp5.addToggle("modeBojeria")
      .setPosition(width - 220, 382)
      .setSize(120, 30)
      .setValue(false)
      .setMode(ControlP5.SWITCH)
      .setLabel("Bojeria: OFF")
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80))
      .setColorActive(color(100, 200, 100))
      .onChange((e) -> {
      boolean estat = e.getController().getValue() > 0;
      String labelBojeria = "Bojeria: " + (estat ? "ON" : "OFF");
      e.getController().setLabel(labelBojeria);
      // boto per tornar al menú d'inici
      botons.play();
      });
      tornarMenu = cp5.addButton("tornarMenu")
      .setLabel("Tornar al menu")
      .setPosition(width/2 - 80, 350)
      .setSize(160, 40)
      .setColorBackground(color(15, 72, 40))
      .setColorForeground(color(80, 180, 80)) 
      .setColorActive(color(100, 200, 100))
      .onClick((e) -> {pantalla = 0;
       botons.play();});
      
  }
}
// funció que para qualsevol de les músiques que sona de l'array de músiques
void paraMusiques(){
 
    for (int i = 0; i < musiques.length; i++) {
      musiques[i].stop();
    }
}
// posa en funcionament la música que teniem seleccionada un cop l'he aturat per fer sonar l'efecte d'entrada al joc
void encenMusica( int musicaActual){
  musiques[musicaActual].loop();
}
// funció que gestiona el canvi de música seleccionada
void canviaMusica(int index) {
  //primer parem qualsevol de les que estigui sonant
  for (int i = 0; i < musiques.length; i++) {
    musiques[i].stop();
  }
  // activem la que rebem pel paràmetre d'entrada
  musiques[index].loop();
  musicaActual = index;
}

//funció que gestiona el nivell del joc. En aquest cas només afecta a la velocitat de la pilota
void canviaNivell(int nivell) {
 
  if (nivell == 0) { 
    velocitatX = 5;
    velocitatY = 5; }
  else if (nivell == 1) { 
    velocitatX = 7; 
    velocitatY = 7; }
  else if (nivell == 2) { 
    velocitatX = 10; 
    velocitatY = 10; }
}

// resetejem la posicó de la pilota, les raquetes u la puntuació un cop comencem el joc
void iniciarJoc() {
  pantalla = 1;
  pilotaX = width/2;
  pilotaY = height/2;
  posicioRaqueta1 = height/2 - allargadaRaqueta/2;
  posicioRaqueta2 = height/2 - allargadaRaqueta/2;
  punts1 = 0;
  punts2 = 0;
  
}
//funció que gestiona la física del joc
void jugar() {
  // aquest bloc de codi serveix per a que no es solapi l'efecte d'entrada a la pantalla que dispara el botó jugar amb l'inici de la música que tenim seleccionada
  if (!senseMusica){
    if (esperantMusica && millis() - tempsIntro >= 2000) {
      encenMusica(musicaActual);
      esperantMusica = false;
    }
  }
  
  //dibuixem la taula de ping pong
  stroke(255);
  strokeWeight(4);
  fill(88, 161, 77);
  rect(60,60, width - 120 ,height - 120);
  //dibuixem les separacions interiors de la taula de ping pong
  strokeWeight(2);
  line(width/2, 60, width/2, height - 60);
  line(60 ,  height/2, width - 60, height/2);
  // dibuixem les dues raquetes
  strokeWeight(0);
  fill(255);
  // raqueta jugador 1
  rect(50, posicioRaqueta1, ampladaRaqueta, allargadaRaqueta); 
  // raqueta màquina o jugador 2
  rect(width - 50 - ampladaRaqueta, posicioRaqueta2, ampladaRaqueta, allargadaRaqueta); 
  // si estem en mode bojeria la pilota anirà canviant de color segons els valors que van retornant les variables r g b. Mateix funcionament que pel background
  if(modeBojeria){
    float r = frameCount*2 % 255; 
    float g = (frameCount*4+ 98) % 255;
    float b = (frameCount*8 + 34) % 255;
    fill(r, g, b);
    strokeWeight(2);
    stroke(255);
    // aquí fem que la velocitat tant vertical com horitzontal vagin canviant de forma al·leatoria a cada frame el que fa que el moviment sigui bastant inprecís
    
    velocitatY += random(-0.3, 0.3);
    velocitatX += random(-0.1, 0.1);
    
  }


  // dibuixem la pilota i li donem una posició a cada frame
  ellipse(pilotaX, pilotaY, 20, 20);
  //resetejem els borders
  strokeWeight(0);
  // actualitzem la posició de la pilota pel següent frame.
  pilotaX += velocitatX;
  pilotaY += velocitatY;
  
  // rebot vertical. El multiplicador és el que fa que canvii de direcció en xocar contra la part superior o inferior de la pantalla
  if (pilotaY <= 0 || pilotaY >= height) {
    velocitatY *= -1;
    cop.play();
  }

  // aquí controlem el jugador 1
  // en aquesta linea conseguim que la velocitat de moviment de la raqueta s'adapti automàticament a la velocitat de la pilota
  // si estem en mode fàcil i la pilota va lenta la raqueta es mou a una velocitat de 3 però si estem en mode difícil i la pilota va més ràpida la raqueta també es mou més ràpidament
  //aquesta variable ens servirà tant pel jugador 1 com per al 2
  float velocitatRaqueta = 0;
  if(modeBojeria){
   velocitatRaqueta =  max(6, abs(velocitatY));; 
  }else{
    velocitatRaqueta = max(3, abs(velocitatY)); 
  }
  // amb la mateixa lògica que apliquem al moviment de la pilota ara l'apliquem a la raqueta depenent de si s'ha apretat la tecla w o s. En aquest cas només es mou en l'eix de les Y
  if (pujarApretat) {
    posicioRaqueta1 -= velocitatRaqueta;
  }
  if (baixarApretat) {
    posicioRaqueta1 += velocitatRaqueta;
  }
  // amb aquesta linea aconseguim que la raqueta estigui dins dels valors de la pantalla gràcies al constraint que força a que el valor de sortida estigui a dins d'un marge
  // aquest marges son els extrems superior i inferior de la pantalla menys l'allargada de la raqueta per a que pari just en tocar l'extrem inferior
  posicioRaqueta1 = constrain(posicioRaqueta1, 0, height - allargadaRaqueta);
  
  //mateixa lògica que amb la raqueta 1 si tenim el mode 2 jugadors seleccionat
  if (segonJugador){

     if (pujarDosApretat) posicioRaqueta2 -= velocitatRaqueta;
     if (baixarDosApretat) posicioRaqueta2 += velocitatRaqueta;
      posicioRaqueta2 = constrain(posicioRaqueta2, 0, height - allargadaRaqueta);
  }
  else{
    // lògica per a que la màquina sigui autónoma
    // cada cop que impacta la fem tornar al centre abans de que torni la pilota. Si no feia això sempre perdia perque no li donava temps d'atravesar la pantalla d'extrem a extrem i arrivar a la pilota la majoria de les vegades
    if (tornaAlCentre) {
      // marquem on està el centre a on voldrem que retorni la raqueta
      float centreY = height / 2 - allargadaRaqueta / 2;
      // amb aquesta variable calculem la distancia entre la posició actual de la raqueta i el centre. Això ens permet saber si l'hem de moure cap amunt i cap abaix i quant
      float distanciaAlCentre = abs(posicioRaqueta2 - centreY);
      // en nivell dificil vaig haver d'incrementar la velocitat de retorn amb aquest ternari perque sinó la màquina sempre perdia.
      float velocitatDeRetorn = nivellDificil ? 8 : 4;
      // si la raqueta està per sobre del centre fem que es mogui cap abaix retornant al centre
      if (posicioRaqueta2 < centreY) {
        posicioRaqueta2 += min(velocitatDeRetorn, distanciaAlCentre);  
      // si està per sota del centre fem que es mogui cap amunt. Amb el min aconseguim que la raueta si està molt aprop del centre no es passi de llarg en aplicar un moviment superior al que realment li queda per arribar  
      // sempre que es passi de llarg el moviment que aplicarà serà només la distancia que li queda per arribar al centre  
    } else {
        posicioRaqueta2 -= min(velocitatDeRetorn, distanciaAlCentre);
      }
    }
    // amb aquest bloc de codi controlem el moviment de la pala de la màquina quan la pilota s'aproxima desde l'esquerra i la pilota ha passat un 75% de la taula de la pantalla. Amb aquest retard en reaccionar conseguim que sigui possible guanyar-la alguna vegada
    else if (pilotaX > width * 0.75 && velocitatX > 0) { 
        // aquí li donem uns pixels d'error al·leatori en el càlcul que fa per situar-se. Això també ens dona marge per poder guanyar algun cop a la màquina
        float nivellDeError = random(-20, 20);
        // es va modificant a mida que la pilota es va apropant i permet a la raqueta situar-se al lloc on arribarà la pilota.
        float prediccioPosicioRaquetaRespectePilota = pilotaY - allargadaRaqueta/2 + nivellDeError;
        // velocitat de moviment de la màquina. En nivell dificil li donem una mica més perqué sino sempre perdia
        float velocitatMaquina = nivellDificil ? 13:10;
      // mateixa lògica que amb la raqueta del jugador 1 pero tenint com a referència la predicció de posicio que es va calculant a cada frame
      if (posicioRaqueta2 + allargadaRaqueta/2 < prediccioPosicioRaquetaRespectePilota){
        posicioRaqueta2 += velocitatMaquina;
      }
      else if (posicioRaqueta2 + allargadaRaqueta/2 > prediccioPosicioRaquetaRespectePilota) {
        posicioRaqueta2 -= velocitatMaquina;
      }
    }
   
  }
  // aquí tenim la lògica que fa que es detecti l'impacte de la pilota amb la raqueta del jugador 1. 
  // si la velocitat es superior a 0 vol dir que la pilota va cap a l'esquerra. Si pilotaX es major o igual a 50 que és la posició en X de la raqueta més l'amplada d'aquesta sabem que a arribat al limit dret de la raqueta
  // i si pilotaY > posicioRaqueta1 && pilotaY < posicioRaqueta1 + allargadaRaqueta sabem que la pilota esta en el rang de l'allargada de la raqueta. Cumplint aquestes condicions sabem que la pilota a impactat a la raqueta
 if (velocitatX < 0 && pilotaX <= 50 + ampladaRaqueta &&
    pilotaY > posicioRaqueta1 && pilotaY < posicioRaqueta1 + allargadaRaqueta) {
      // canviem de sentit la velocitat que moura la posició de la pilota
      velocitatX *= -1;
      // amb això coloquem la pilota fora de la raqueta en rebotar evitant que tornes a rebotar amb l'altre extrem de la raqueta
      pilotaX = 50 + ampladaRaqueta + 1;
      //efecte de so en impactar
      cop.play();
    }
   //mateixa lògica que hem aplicat amb el segon jugador pero ara amb ala màquina
   posicioRaqueta2 = constrain(posicioRaqueta2, 0, height - allargadaRaqueta);
    if (velocitatX > 0 && pilotaX > width / 2 && tornaAlCentre) {
    tornaAlCentre = false;
    }

  //mateixa lògica que abans pero amb la pala de la màquina
  if (velocitatX > 0 && pilotaX + 10 >= width - 50 - ampladaRaqueta &&
      pilotaY >= posicioRaqueta2 && pilotaY <= posicioRaqueta2 + allargadaRaqueta) {
      velocitatX *= -1;
      cop.play();
      pilotaX = width - 50 - ampladaRaqueta -10 ;
      tornaAlCentre = true;
  }

  // gestionem la suma de punts un cop la pilota travessa el limit on es troben les raquetes. Si es passa per la banda de l'esquerra es suma un punt o a la màquina o al jugador dos. I per la dreta al jugador 1
  if (pilotaX < ampladaRaqueta - 50) {
    punts2 +=1;
    punt.play();
    // ens permet gestionar el missatge de la pantallaGameOver i pantallaGuanyador 
    ultimGuanyador = 2;
    reiniciarPilota();
    
  } else if (pilotaX > width - ampladaRaqueta  ) {
    punts1 +=1;
    punt.play();
    ultimGuanyador = 1;
    reiniciarPilota();
  }

  // text on veiem la puntuació
  fill(255);
  textSize(32);
  textAlign(CENTER);
  text(punts1 + " : " + punts2, width/2, 50);
  // un cop un dels dos jugadors supera el limit de punts es canvia de pantalla i depenent de les variables d'un o dos jugadors i la variable ultimGuanyador es va a una funcio o un altre i es mostren missatges diferents
  if (punts1 >= limitPunts || punts2 >= limitPunts) {
    pantalla = 2;
  }  
  // aquest bloc de codi gestiona els obstacle invisible. Son 5 rectangles que es mouen a diferents velocitats i posicions de la pantalla de manera horitzontal i fan rebotar inesperadament a la pilota sense que els jugadors sàpiguen quan passa.
  
  if(obstaclesInvisibles){
    // anem actualitzan la posició horitzontal, en les x , de cada obstacle a cada frame
    rect_1_x = rect_1_x - velocitatX*.5;
    rect_2_x = rect_2_x - velocitatX*.4;
    rect_3_x = rect_3_x - velocitatX*1.3;
    rect_4_x = rect_4_x - velocitatX*.5;
    rect_5_x = rect_5_x - velocitatX*1.5;
   //detectem si la pilota impacta per la part inferior d'algun obstacle
   if (velocitatY < 0 &&(pilotaX > rect_1_x && pilotaX < rect_1_x + 100 &&
      pilotaY > rect_1_y && pilotaY < rect_1_y + 40 || pilotaX > rect_2_x && pilotaX < rect_2_x + 100 &&
      pilotaY > rect_2_y && pilotaY < rect_2_y + 40 || pilotaX > rect_3_x && pilotaX < rect_3_x + 100 &&
      pilotaY > rect_3_y && pilotaY < rect_3_y + 40 || pilotaX > rect_4_x && pilotaX < rect_4_x + 100 &&
      pilotaY > rect_4_y && pilotaY < rect_4_y + 40 || pilotaX > rect_5_x && pilotaX < rect_5_x + 100 &&
      pilotaY > rect_5_y && pilotaY < rect_5_y + 40)) {
        if(millis() - ultimRebot >= 50){
          // si impacta canviem la direcció de moviment de la pilota
          velocitatY = -1 * velocitatY;
          cop.play();
          // ultim rebot permet que no faci un efecte extrany en que la pilota algunes vegades rebotava molts cops seguits
          ultimRebot = millis();
        }
    
    }
 
  // El mateix si la pilota impacta desde l part superior
  if (velocitatY > 0 && (
    (pilotaX > rect_1_x && pilotaX < rect_1_x + 100 &&
     pilotaY > rect_1_y && pilotaY < rect_1_y + 20) ||
    (pilotaX > rect_2_x && pilotaX < rect_2_x + 100 &&
     pilotaY > rect_2_y && pilotaY < rect_2_y + 20) ||
    (pilotaX > rect_3_x && pilotaX < rect_3_x + 100 &&
     pilotaY > rect_3_y && pilotaY < rect_3_y + 20) ||
    (pilotaX > rect_4_x && pilotaX < rect_4_x + 100 &&
     pilotaY > rect_4_y && pilotaY < rect_4_y + 20) ||
    (pilotaX > rect_5_x && pilotaX < rect_5_x + 100 &&
     pilotaY > rect_5_y && pilotaY < rect_5_y + 20))) {

    //un intent d'evitar que la pilota entri en bucles extranys. El fet de fer servir random() tot i que he procurat limitar el rang d'aquest a vegades té efectes inesperats
    // si fa menys de 50ms que ha rebotat s'ignora. Aquesta xifra la vaig trobar després de prova error.  
    if (millis() - ultimRebot >= 50) {
     
      velocitatY = -1 * velocitatY;
      cop.play();
      ultimRebot = millis(); 
    }
   }
  }
}

// resetejem els obstacles en sortir de la pantalla de joc per a que canviín de posició a la següent partida
void resetejaObstacles(){
  rect_1_x = random(0,width);
  rect_1_y = random(0,height - 200);
  rect_2_x =  random(0,width);
  rect_2_y =random(0,height - 200);
  rect_3_x =  random(0,width);
  rect_3_y = random(0,height - 200 );
  rect_4_x =  random(0,width);
  rect_4_y = random(0,height - 200);
  rect_5_x =  random(0,width);
  rect_5_y = random(0,height - 200);
  
}
// depenent de qu guanya l'ultim punt la pilota surt desde la seva raqueta igual que al ping pong real
void reiniciarPilota() {

  resetejaObstacles();
  posicioRaqueta2 = height/2 -allargadaRaqueta /2;
  // col·loca la pilota centrada a la raqueta del guanyador
  if (ultimGuanyador == 1) {
    pilotaX = 70;
    pilotaY = posicioRaqueta1 + allargadaRaqueta / 2;
    
  } else {
    // el mateix quan qui guanya és la màquina o el jugador 2
    pilotaX = width - 70;
    pilotaY = posicioRaqueta2 + allargadaRaqueta / 2;

  }

}
//pantalla que surt un cop s'acapa la partida contra la màquina. Depenent de qui guanya surt un misatge o un altre
void pantallaGameOver(int ultimGuanyador,  int punts1, int  punts2) {
  // parem l úsica en entrar per a poder reproduir o el so de victoria o de gameOver
  if(!noSonaMusica){
    paraMusiques();
    if(ultimGuanyador==1){
     victoria.play(); 
    } else{
      gameOver.play();
    }
  }
  noSonaMusica = true;
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(40);
  //escrivim un text o un altre depenent de qui ha guanyat
  if(ultimGuanyador==1){
    textSize(30);
    text("ENHORABONA!! HAS GUANYAT A LA MÀQUINA", width / 2, height / 2 - 50);
  }else{
    text("GAME OVER", width / 2, height / 2 - 50);
  }
  textSize(20);
  //mostrem la puntuació final
  text("Puntuació " + punts1 + " a " + punts2, width / 2, height / 2 - 20);
  //informem de com tornar al menú d'inici
  text("Prem ESPAI per tornar al menú", width / 2, height / 2 + 10);
}
// mateixa lògica pero per quan estem en el mode de dos jugadors
void pantallaGuanyador(int ultimGuanyador , int punts1, int punts2) {
   if(!noSonaMusica){
      paraMusiques();
      victoria.play();
   }
   noSonaMusica = true;
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(40);
  text("Ha guanyat el jugador " + ultimGuanyador, width / 2, height / 2 - 50);
  text("Puntuació " + punts1 + "  a  " + punts2, width / 2, height / 2 - 90);
  textSize(20);
  text("Prem ESPAI per tornar al menú", width / 2, height / 2 + 10);
}
// funció de processing per gestionar les tecles que controlen el joc
void keyPressed() {
  
  if (pantalla == 1 && key == ' ') {

    pantalla = 0;
    menuInicialitzat=false;

  }
  if (pantalla == 2 && key == ' ') {
    pantalla = 0;
    menuInicialitzat=false;

  }
  if (key == 'w') pujarApretat = true;
  if (key == 's') baixarApretat = true;
  if (keyCode == UP) { 
    pujarDosApretat = true;
  }
  if (keyCode == DOWN) {
    baixarDosApretat = true;
  }
}

void keyReleased() {
  if (key == 'w') pujarApretat = false;
  if (key == 's') baixarApretat = false;
  if (keyCode == UP) { 
    pujarDosApretat = false;
  }
  if (keyCode == DOWN) {
    baixarDosApretat = false;
  }
}
//funcions que destrueixen els botons un cop surtim de les pantalles on es mostren
void amagaBotonsMenu(){
  botoConfig.remove();
  botoIniciJoc.remove();
  botoExit.remove();
  
}
void amagaBotonsConfig(){
  musica1.remove();
  musica2.remove();
  musica3.remove();
  senseMusiques.remove();
  facil.remove();
  intermig.remove();
  dificil.remove();
  unJugador.remove();
  dosJugadors.remove();
  botoObstaclesInvisibles.remove();
  botoModeBojeria.remove();
  tornarMenu.remove();
  
} 

// funció per la pantalla exit
void pantallaSortida(){
   // aquesta variable s'inicialitza com a false pel que s'activarà just al entrar a la pàgina i ens servirà 
   // com a referencia per a poder calcular quan passen 5 segons , ja que al entrar només una vegada es quedarà amb un valor fixe 
   // a diferència de millis() que canvia continuament
   if(!començaAContar){
    començaAContar = true;
    tempsALaPagina = millis();
   }
  
   textSize(30);
   textAlign(CENTER);
   text("Gràcies per jugar. Fins aviat!", width/2, height/2);

   if(millis() - tempsALaPagina > 3000){
        exit();
     }
   // variable a 4 per a que draw() sàpiga que ha de pintar aquesta funció
   pantalla=4;
   
}
