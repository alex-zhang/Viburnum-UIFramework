package com.viburnum.logging
{
	public class TraceLoggingTarget extends AbstractLoggingTarget
	{
		public function TraceLoggingTarget()
		{
			super();
		}
		
		override protected function formatLogItem(logLevel:int, message:String):Object
		{
			return [logLevel, message, new Date().toString()];
		}
		
		override protected function onFormatLogItemLog(formattedLogItem:Object):void
		{
			var logLevel:String = logLevelToString(formattedLogItem[0]);
			trace("[" + logLevel + "]: " + formattedLogItem[1] + " " + formattedLogItem[2]);
		}
	}
}