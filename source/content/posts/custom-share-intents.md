![image](../custom-share-intents/img_header.png)

<p style="text-align: justify;">
El articulo se centra en poder personalizar la lista de ShareIntents en tu dispositivo móvil para poder compartir algún tipo de Datos (Imágenes, Texto Plano, enlaces, etc.) a través de dichas aplicaciones o redes sociales. 
</p>

## ¿Cuál es la novedad?
<p style="text-align: justify;">
Hasta este punto se podría hacer uso de los componentes nativos que el sistema operativo nos proporciona:
<ul type="disk">
<li>¿Que pasa si deseamos compartir cierta información solo con algunas aplicaciones especificas..? </li>
<li>¿Agregar algún componente o efecto a la hora de mostrar la lista..? </li>
<li>¿Personalizar los ítems de la lista a mi antojo..?</li>
<li>¿Cambiar el tipo de fuente de la lista..?</li>
</ul>
</p>
<p style="text-align: justify;">
Simplemente no se podría, ya que la interfaz de compartir que nos muestra de forma nativa, cambia según la versión de Android que posea el usuario, para ello en este articulo te mostrare la personalización del ShareIntents en un <b>RecyclerView</b> agregando el <b>BottomSheetDialog</b> y que actualmente aplicaciones como GoogleMaps, Youtube, Facebook la usan, consiguiendo una mejor interacción con el usuario.
</p>

> **BottomSheetDialog:** Fue incluido en la Biblioteca de Soporte 23.2 donde se intenta ofrecer versiones de API compatibles con lanzamientos anteriores.

## ¿Cómo enviamos datos hacia otras aplicaciones? 
<p style="text-align: justify;">
Cuando construimos un Intent, debemos especificar la acción que deseas que el intento "dispare". Android define varias acciones, incluida la ACTION_SEND que, como probablemente pueda adivinar, indica que la intención es enviar datos de una actividad a otra, incluso a través de los límites del proceso. Para enviar datos a otra actividad, todo lo que necesita hacer es especificar los datos y su tipo, el sistema identificará las actividades de recepción compatibles y las mostrará al usuario (si hay varias opciones) o iniciará inmediatamente la actividad (si solo hay una opción). 
</p>

```java
Intent sendIntent = new Intent();
sendIntent.setAction(Intent.ACTION_SEND);
sendIntent.putExtra(Intent.EXTRA_TEXT, "This is my text to send.");
sendIntent.setType("text/plain");
startActivity(Intent.createChooser(sendIntent, getResources().getText(R.string.send_to)));
```
<p style="text-align: justify;">
En realidad al pasar el dato hacia otra aplicación, estamos comunicando 2 Actividades, donde la Actividad Emisora es la nuestra  y la que recepciona  el mensaje es la Actividad de la aplicación seleccionada, al crear el Intent de Tipo SEND, pasándole un dato de Texto plano, android nos devuelve ya un componente nativo  que contiene la lista donde solamente especificaremos la aplicación en donde compartir dicho dato.
</p>

<div align="center"> <img src="../custom-share-intents/img_share_default.png" width=250px heigth=500px > </div>

## Share Intents  Personalizados
Ahora para poder personalizar los Share Intents seguiremos los siguientes pasos:

1. Obtener a la lista de Aplicaciones de tipo SEND.

2. Mostrar la lista  en el RecyclerView (Icono y Nombre  de la aplicación).

3. Vincular nuestra Actividad con el ShareActivity de la aplicación seleccionada.

4. Implementar el BottomSheetDialog con el RecyclerView.

Listo ahora manos a la obra :muscle: :construction_worker: :muscle: :muscle: ..!!

## 1. Obtener a la lista de Aplicaciones de tipo SEND.
<p style="text-align: justify;">
Obtenemos  la lista  de aplicaciones tipo SEND, instaladas en nuestro dispositivos móvil, donde haremos uso del <b>getPackageManager()</b> para acceder al <b>queryIntentActivities()</b> donde le pasamos como parámetro el intent especificando el tipo de Acción y el tipo de Datos a Compartir y  obtendremos una lista de tipo ResolveInfo.
</p>

```java
Intent shareIntent = new Intent(Intent.ACTION_SEND);
shareIntent.setType(Constant.SHARE_TYPE);
List<ResolveInfo> resolverInfoList = packageManager.queryIntentActivities(shareIntent, 0);
```
## 2. Mostrar la lista  en el RecyclerView (Icono y Nombre  de la aplicación).
<p style="text-align: justify;">
Posteriormente debemos de obtener el nombre de la aplicación con el <b>loadLabel()</b> y el Icono con el <b> loadIcon()</b> del objeto ResolveInfo de la Lista obtenida previamente.
</p>

```java
 class ShareAppTask extends AsyncTask<Void, Void, List<AppInfo>> {
        @Override
        protected List<AppInfo> doInBackground(Void... voids) {
            Intent shareIntent = new Intent(Intent.ACTION_SEND);
            shareIntent.setType(Constant.SHARE_TYPE);
            List<ResolveInfo> resolverInfoList = packageManager.queryIntentActivities(shareIntent, 0);
            List<AppInfo> appInfoList = new ArrayList<>();
            if (!resolverInfoList.isEmpty() && !isCancelled()) {
                //Creación del Modelo AppInfo
                for (ResolveInfo resolveInfo : resolverInfoList) {
                    AppInfo appInfo = new AppInfo();
                    appInfo.setActivityInfo(resolveInfo.activityInfo);
                    appInfo.setName(resolveInfo.loadLabel(packageManager).toString());
                    appInfo.setPackageName(resolveInfo.activityInfo.packageName);
                    appInfo.setIcon(resolveInfo.loadIcon(packageManager));
                    appInfoList.add(appInfo);
                }
            }
            return appInfoList;
        }
    }
```
<p style="text-align: justify;">
Para poder tener un código mas limpio se recomienda crear un Modelo aparte, donde tenga como atributos por ejemplo el Nombre de la Aplicación ,Icono, Tipo, etc. y llevar el proceso a Segundo Plano ya que muchas veces el acceder al <b>queryIntentActivities()</b> y hacer el recorrido  según el criterio de listado que desee, podría matar al hilo principal, en este caso se usa un <b>Asyntask</b>.
</p>

## 3. Vincular nuestra Actividad con el ShareActivity de la aplicación seleccionada.
<p style="text-align: justify;">
Para poder vincular nuestra actividad debemos de crear un ComponentName  en el cual especificamos el nombre del paquete y el nombre del ActivityInfo de la aplicación seleccionada.
El ComponentName es una clase que nos permite  acceder a una  aplicación única con dichos parámetros, ya que en el caso de Facebook o Google algunas aplicaciones tienen el mismo nombre de paquete  pero con dicho componente accedemos a la aplicación de manera correcta para compartir información.
</p>

```java
ComponentName componentName = new ComponentName(packageName, activityInfo.name);
String message = getString(R.string.cip_genetate_share_message, fullName, tvMessage.getText(), codeCip, tvCipExpiry.getText());
Intent shareIntent = new Intent(Intent.ACTION_SEND);
shareIntent.setType(Constant.SHARE_TYPE);
shareIntent.putExtra(Intent.EXTRA_TEXT, message);
shareIntent.setComponent(componentName);
startActivity(shareIntent);    
```
## 4. Implementar el BottomSheetDialog con el RecyclerView
<p style="text-align: justify;">
El BottomSheetDialog es un componente que se incluyo en la Biblioteca de soporte 23.2 y es  compatible con versiones anteriores.
</p>

> Mas información: https://material.io/guidelines/components/bottom-sheets.html#

```java
BottomSheetDialog mBottomSheetDialog = new BottomSheetDialog (getActivity());
View sheetView = getActivity ().getLayoutInflater().Inflate (R.layout.fragment_bottom_sheet,null);
mBottomSheetDialog.setContentView (sheetView) ; 
mBottomSheetDialog.show () ;
```
<p style="text-align: justify;">
Se puede establecer una altura relativa a la hora de realizar gestos con el Touch en el  BottomSheetDialog, simplemente agregando la siguiente sentencia de código,  en el caso de PagoEfectivoWallet3.0 se estable como altura relativa a la altura del ViewPager del <b>GenerateCipActivity</b> para que el usuario no pierda la visualización del código generado al inflar el BottomSheetDialog.
</p>

```java
BottomSheetBehavior bottomSheetBehavior = BottomSheetBehavior.from(((View) view.getParent()));
bottomSheetBehavior.setPeekHeight(heigthRelative);
```
<p style="text-align: justify;">
Es recomendable crear una clase aparte para no ensuciar el código, también el usuario creare su XML (Fragment_bottom_sheet) donde contendrá el RecyclerView previamente preparado.
</p>

```java
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/llBottomSheet"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/colorWhite"
    android:orientation="vertical"
    android:padding="16dp">
    <LinearLayout
     android:id="@+id/llHeader"
     ....
    </LinearLayout>
    <FrameLayout
        android:layout_width="match_parent"
        android:layout_height="match_parent">

        <android.support.v7.widget.RecyclerView
            android:id="@+id/rvShare"
            android:layout_width="match_parent"
            android:layout_height="match_parent"
            tools:listitem="@layout/item_share" />
        <LinearLayout
          android:id="@+id/llLoad"
          ......
        </LinearLayout>
    </FrameLayout>
</LinearLayout>
```
<div align="center"> <img src="../custom-share-intents/bottomsheet.gif" width=300px heigth=600px> </div>


## Bibliografía

 - https://stackoverflow.com/questions/7545254/android-and-facebook-share-intent

 - https://developer.android.com/training/sharing/send.html

 - https://material.io/guidelines/components/bottom-sheets.html#

 - https://stackoverflow.com/questions/6827407/how-to-customize-share-intent-in-android

 - https://medium.com/@anitas3791/android-bottomsheetdialog-3871a6e9d538





