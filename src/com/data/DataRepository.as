package com.data
{
	import com.fxpn.events.XMLLoaderEvent;
	import com.google.maps.InfoWindowOptions;
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	import com.google.maps.Map;
	import com.google.maps.MapMouseEvent;
	import com.google.maps.overlays.MarkerOptions;
	import com.ui.StationMarker;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class DataRepository 
	{
		private static var stations:Array;
		private static var stationsV:Array = [];
		private static var stationsH:Array = [];
		private static var lines:Array = [];
		
		public static function loadData():void
		{
			var urlLoader:URLLoader = new URLLoader();
			urlLoader.addEventListener(Event.COMPLETE, onDataReady);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onDataError);
			urlLoader.load(new URLRequest("../data/bus.txt"));
		}
		
		private static function onDataReady(event:Event):void
		{
			var rawArray:Array = (event.target.data as String).split("),\n(");
			stations = new Array(100000);
			lines = new Array(10000);
			for each (var entry:String in rawArray)
			{
				var rawEntry:Array = entry.split(", ");
				var stationId:int = parseInt(rawEntry[4]);
				var lineNumber:int = parseInt(rawEntry[1]);
				if (stationId==0 || lineNumber == 0) continue;
				if (stations[stationId] == null)
				{
					var station:StationData = new StationData(rawEntry);
					stationsH.push(station);
					//stationsV.push(station);
					stations[stationId] = station;
				}
				else
				{
					(stations[stationId] as StationData).addLine(lineNumber,parseInt(rawEntry[2]));
				}
				if (lines[lineNumber] == null)
				{
					lines[lineNumber] = new LineData(lineNumber,stationId);
				}
				else
				{
					(lines[lineNumber] as LineData).addStation(stationId);
				}
			}
			stationsH.sortOn("lng",Array.NUMERIC);
			stationsV.sortOn("lat",Array.NUMERIC);	
		}
		
		private static function onDataError(event:XMLLoaderEvent):void
		{
			
		}
		
		public static function findStationsInBound(bounds:LatLngBounds, map:Map, origLatLng:LatLng, distance:Number):Array
		{
			var westLng:Number = bounds.getWest();
			var eastLng:Number = bounds.getEast();
			var mostWestStationIndex:int = -1;
			var mostEastStationIndex:int = -1;
			var min:int = 0;
			var max:int = stationsH.length - 1;
			var mid:int = (min + max)/2;
			var currLng:Number;
			var otherLng:Number;
			
			if (stationsH[max].lng > westLng && stationsH[0].lng < eastLng)
			{	
				if (stationsH[0].lng > westLng)
				{
					mostWestStationIndex = 0;
				}
				else
				{			
					while (true)
					{	
						if (stationsH[mid].lng > westLng && stationsH[mid-1].lng < westLng)
						{
							mostWestStationIndex = mid;
							break;
						}
						else if (stationsH[mid].lng > westLng)
						{
							max = mid - 1;
							mid = (min + max)/2;
						}
						else
						{
							min = mid + 1;
							mid = (min + max)/2;
						}
					}
				}
				min = 0;
				max = stationsH.length - 1;
				mid = (min + max)/2;
				if (stationsH[max].lng < eastLng)
				{
					mostEastStationIndex = max;
				}
				else
				{
					while (true)
					{	
						if (stationsH[mid].lng < eastLng && stationsH[mid+1].lng > eastLng)
						{
							mostEastStationIndex = mid;
							break;
						}
						else if (stationsH[mid].lng > eastLng)
						{
							max = mid - 1;
							mid = (min + max)/2;
						}
						else
						{
							min = mid + 1;
							mid = (min + max)/2;
						}
					}
				}
			}
			
			var nearStations:Array = [];
			if (mostEastStationIndex > -1 && mostWestStationIndex > -1)
			{
				var northLat:Number = bounds.getNorth();
				var southLat:Number = bounds.getSouth();
				var markerOptions:MarkerOptions = new MarkerOptions({fillStyle: {color: 0xaaaa00}});
				for (var i:int = mostWestStationIndex; i <= mostEastStationIndex; i++)
				{
					var currLatLng:LatLng = new LatLng(stationsH[i].lat,stationsH[i].lng);
					var stationDistanceFromSource:Number = origLatLng.distanceFrom(currLatLng)
					if (stationsH[i].lat < northLat && stationsH[i].lat > southLat && stationDistanceFromSource<distance)
					{
						(stationsH[i] as StationData).distance = stationDistanceFromSource;
						nearStations.push(stationsH[i]);
						
						/*var stationMarker:StationMarker = new StationMarker(stationsH[i],markerOptions);
						stationMarker.addEventListener(MapMouseEvent.CLICK, onClickMarker); 				
						map.addOverlay(stationMarker);*/
					}
				}
				nearStations.sortOn("distance",Array.NUMERIC);				
			}
			return nearStations;
		}

		private static function onClickMarker(event:MapMouseEvent):void
		{
			var marker:StationMarker = event.target as StationMarker;
			var lat:Number = marker.stationData.lat;			
			marker.openInfoWindow(new InfoWindowOptions({title: "Station No." + marker.stationData.id,contentHTML: marker.stationData.description})); 
		}
		
		public static function getStationData(id:int):StationData
		{
			return stations[id];
		}
		
		public static function getLineData(lineNumber:int):LineData
		{
			return lines[lineNumber];
		}
	}
}