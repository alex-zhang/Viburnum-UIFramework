package com.viburnum.logging
{
	public class AbstractLoggingTarget implements ILoggingTarget
	{
		private var _recodeLoggingLevel:int = int.MAX_VALUE;//vv
		private var _rcodedLoggingData:Array = [];
		private var _isEnableRecodeLoggingData:Boolean = false;
		
		public function AbstractLoggingTarget()
		{
			super();
		}
		
		//ILoggingTarget
		public function getRcodedLoggingDatas():Array
		{
			return _rcodedLoggingData.concat();
		}
		
		public function setRecodeLoggingLevel(value:int):void
		{
			_recodeLoggingLevel = value;
		}
		
		public function setEnableRecodeLoggingData(value:Boolean):void
		{
			_isEnableRecodeLoggingData = value;
		}
		
		public final function log(logLevel:int, message:String):void
		{
			if(logLevel >= _recodeLoggingLevel)
			{
				var formattedLogItem:Object = formatLogItem(logLevel, message);
				
				if(_isEnableRecodeLoggingData)
				{
					_rcodedLoggingData.push(formattedLogItem);
				}
				
				onFormatLogItemLog(formattedLogItem);
			}
		}
		
		protected function formatLogItem(logLevel:int, message:String):Object
		{
			return null;
		}
		
		protected function onFormatLogItemLog(formattedLogItem:Object):void
		{
		}
		
		protected final function logLevelToString(logLevel:int):String
		{
			switch(logLevel)
			{
				case LogLevel.FATAL:
					return "FATAL";
					break;
				
				case LogLevel.ERROR:
					return "ERROR";
					break;
				
				case LogLevel.WARN:
					return "WARN";
					break;
				
				case LogLevel.INFO:
					return "INFO";
					break;
				
				case LogLevel.DEBUG:
					return "DEBUG";
					break;
				
				case LogLevel.ALL:
					return "ALL";
					break;
			}
			
			return "UNKNOWN";
		}
	}
}