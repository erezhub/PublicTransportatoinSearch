package com.data
{
	public class StationData
	{
		private var _id:int;
		private var _lat:Number;
		private var _lng:Number;
		private var _name:String;
		private var _description:String;
		private var lines:Array;
		private var linesDirections:Array;
		
		public var distance:Number;
		
		public function StationData(rawData:Array)
		{
			var cleanData:Array = [];
			var str:String;	
			for (var i:int = 0; i < rawData.length; i++)
			{				
				//trace(a[i],(a[i] as String).charAt(1) == "'");
				if ((rawData[i] as String).charAt() == "'")
				{
					if (rawData[i].charAt(rawData[i].length-1)=="'")
					{
						str = (rawData[i] as String).substring(1,rawData[i].length-1);
						cleanData.push(str);
					}
					else //if ((rawData[i+1] as String).charAt(rawData[i+1].length-1)!="'")
					{
						str = rawData[i];
						while (rawData[i].charAt(rawData[i].length-1)!="'")
						{
							str = str.concat(", ",rawData[i+1]); 
							i++;
						}
						str = str.substring(1,str.length-1);
						cleanData.push(str);
					}
				}
				else if (rawData[i].indexOf(".")==-1)	
				{
					cleanData.push(parseInt(rawData[i]));
				}
				else
				{
					cleanData.push(parseFloat(rawData[i]));
				}
				
			}
			_id = cleanData[4];
			_lat = cleanData[13] + 0.0005;
			_lng = cleanData[14] - 0.0016;
			_name = cleanData[5];
			_description = "<font face='_sans'><b>Name: </b>" + cleanData[5] + "<br><b>Address: </b>" + cleanData[6] + "<br>" + cleanData[7] 
			               + ", " + cleanData[8] + "<br><b>Available lines: </b>";
			lines = [cleanData[1]];	
			linesDirections = [{line: cleanData[1],direction: cleanData[2]}];		
		}
		
		public function get id():int
		{
			return _id;
		}
		
		public function get lat():Number
		{
			return _lat;
		}
		
		public function get lng():Number
		{
			return _lng;
		}
		
		public function get description():String
		{
			lines.sort(Array.NUMERIC);
			return _description + lines+"</font>";
		}
		
		public function get name():String
		{
			return _name;	
		}		
		
		public function addLine(line:int, direction:int):void
		{
			if (lines.indexOf(line) == -1 && line) // TODO: what if stations has a line's both directions
			{ 
				lines.push(line);
				linesDirections.push({line: line, direction: direction});
			}
		}
		
		public function getLineDirectionByIndex(index:int):Object
		{
			return linesDirections[index];
		}
		
		public function get totalLines():int
		{
			return lines.length;
		}
		
		public function hasLine(line:int, direction:int):Boolean
		{
			for (var i:int = 0; i < linesDirections.length; i++)
			{
				if (linesDirections[i].line == line && linesDirections[i].direction == direction)
				{
					return true;
				}
			}
			return false;
		}
		
		public function toString():String
		{
			return id.toString(); 
		}
	}
}