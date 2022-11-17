package com.ui
{
	import com.data.StationData;
	import com.google.maps.LatLng;
	import com.google.maps.overlays.Marker;
	import com.google.maps.overlays.MarkerOptions;

	public class StationMarker extends Marker
	{
		private var _station:StationData;
		
		public function StationMarker(station:StationData, markerOption:MarkerOptions = null)
		{
			super(new LatLng(station.lat,station.lng), markerOption);
			_station = station;
		}
		
		public function get stationData():StationData
		{
			return _station;
		}
		
	}
}