package com.viburnum.logging
{
	public interface ILoggingTarget
	{
		function getRcodedLoggingDatas():Array;
		
		function setRecodeLoggingLevel(value:int):void;
		function setEnableRecodeLoggingData(value:Boolean):void;
		
		function log(logLevel:int, message:String):void;
	}
}