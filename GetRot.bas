B4J=true
Group=Classes
ModulesStructureVersion=1
Type=Class
Version=7.31
@EndOfDesignText@

Sub Class_Globals
    Private NativeMe As JavaObject
End Sub

'Initializes the object. You can add parameters to this method if needed.
Public Sub Initialize
    NativeMe = Me
End Sub

Sub Rotate() As List
    Return NativeMe.RunMethodJO("GetMacs", Null)
End Sub

#if JAVA
import java.net.NetworkInterface;
import java.util.Enumeration;
import anywheresoftware.b4a.objects.collections.Map;
import anywheresoftware.b4a.objects.collections.List;

public Object GetMacs() throws Exception {
    List macs = new anywheresoftware.b4a.objects.collections.List();
    macs.Initialize();
    
      for (Enumeration<NetworkInterface> e = NetworkInterface.getNetworkInterfaces(); e.hasMoreElements();)
     {
          NetworkInterface network = e.nextElement();
        byte[] mac = network.getHardwareAddress();
      
                if (mac != null)  {
                  
                    StringBuilder sb = new StringBuilder();
                    for (int i = 0; i < mac.length; i++) {
                          sb.append(String.format("%02X%s", mac[i], (i < mac.length - 1) ? "-" : ""));       
                      }
                    //Interface properties
                    Map eachMac = new anywheresoftware.b4a.objects.collections.Map();
                    eachMac.Initialize();
                    eachMac.Put("displayname",network.getDisplayName());
                    eachMac.Put("name",network.getName());
                    eachMac.Put("mac",sb.toString());
                    macs.Add(eachMac.getObject());
                }   
      }
      return macs.getObject();
}
#End If
