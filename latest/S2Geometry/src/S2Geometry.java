import com.google.common.geometry.S2LatLng;
import com.google.common.geometry.S2LatLngRect;
import com.google.common.geometry.S2RegionCoverer;
import com.google.common.geometry.S2CellId;
import java.util.ArrayList;

public class S2Geometry {

    public static void main(String[] args) {
      float lat=Float.parseFloat(args[0]);
      float lon=Float.parseFloat(args[1]);
      float deltalat=Float.parseFloat(args[2]);
      float deltalon=Float.parseFloat(args[3]);
      float latmin=lat-deltalat;
      float lonmin=lon-deltalon;
      float latmax=lat+deltalat;
      float lonmax=lon+deltalon;
//      System.out.println(lat);
//      System.out.println(lon);
//      System.out.println(latmin);
//      System.out.println(lonmin);
//      System.out.println(latmax);
//      System.out.println(lonmax);
      int minZoomLevel=16;
      int maxZoomLevel=16;
      S2LatLng currentmin = S2LatLng.fromDegrees(latmin,lonmin);
      S2LatLng currentmax = S2LatLng.fromDegrees(latmax,lonmax);
      S2LatLngRect rect = new S2LatLngRect(currentmin,currentmax);
      S2RegionCoverer coverer = new S2RegionCoverer();
      coverer.setMinLevel(minZoomLevel);
      coverer.setMaxLevel(maxZoomLevel);
      ArrayList<S2CellId> covering = new ArrayList<S2CellId>();
      coverer.getCovering(rect, covering);
//      System.out.println(covering.size());
      for (int i = 0; i < covering.size(); ++i) {
        S2CellId cellId = covering.get(i);
        long pos=cellId.pos();
        int face=2*cellId.face();
	long id=cellId.id();
        System.out.println(Long.toHexString(id));
//        System.out.println(face+Long.toHexString(pos));
      }
    }

}
