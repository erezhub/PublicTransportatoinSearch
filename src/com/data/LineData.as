package com.data
{
	public class LineData
	{
		private var _lineNumber:int;
		private var stations:Array;
		
		public function LineData(lineNumber:int, stationId:int)
		{
			_lineNumber = lineNumber;
			stations = [stationId];
		}
		
		public function addStation(stationId:int):void
		{
			if (stations.indexOf(stationId) == -1) stations.push(stationId);
		}
		
		public function get lineNumber():int
		{
			return _lineNumber;
		}
		
		public function get totalStations():int
		{
			return stations.length;
		}
		
		public function getStationIdByIndex(index:int):void
		{
			//return stations[index];
		}

	}
}