package com.viburnum.logging
{
	import com.alex.utils.StringUtil;

	public final class Logger
	{
		private static var _loggingTarget:ILoggingTarget = null;

		public static function set loggingTarget(value:ILoggingTarget):void
		{
			_loggingTarget = value;
		}
		
		public static function get loggingTarget():ILoggingTarget
		{
			return _loggingTarget;
		}
		
		public static function log(msg:String, ... rest):void
		{
			if(_loggingTarget == null) return;
			
			msg = StringUtil.substitute(msg, rest);
			_loggingTarget.log(LogLevel.ALL, msg);
		}
		
		public static function debug(msg:String, ... rest):void
		{
			if(_loggingTarget == null) return;
			
			msg = StringUtil.substitute(msg, rest);
			_loggingTarget.log(LogLevel.DEBUG, msg);
		}
		
		public static function error(msg:String, ... rest):void
		{
			if(_loggingTarget == null) return;
			
			msg = StringUtil.substitute(msg, rest);
			_loggingTarget.log(LogLevel.ERROR, msg);
		}
		
		public static function fatal(msg:String, ... rest):void
		{
			if(_loggingTarget == null) return;
			
			msg = StringUtil.substitute(msg, rest);
			_loggingTarget.log(LogLevel.FATAL, msg);
		}
		
		public static function info(msg:String, ... rest):void
		{
			if(_loggingTarget == null) return;
			
			msg = StringUtil.substitute(msg, rest);
			_loggingTarget.log(LogLevel.INFO, msg);
		}
		
		public static function warn(msg:String, ... rest):void
		{
			if(_loggingTarget == null) return;
			
			msg = StringUtil.substitute(msg, rest);
			_loggingTarget.log(LogLevel.WARN, msg);
		}
	}
}