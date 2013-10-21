package com.viburnum.layouts
{
	public final class PositionConstrainType
	{
		public static const CENTER:String = "center";
		
		public static const TOP_LEFT:String = "tl";
		public static const TOP_RIGHT:String = "tr";
		public static const BOTTOM_LEFT:String = "bl";
		public static const BOTTOM_RIGHT:String = "br";
		
		public static const TOP_CENTER:String = "tcenter";
		public static const TOP_CUSTOM:String = "tcustom";//y=0,x自定
		public static const TOP_CUSTOM_LIMITED:String = "tcustomLimit";//y=0,x自定,但受最小最大范围约束
		
		public static const BOTTOM_CENTER:String = "bcenter";
		public static const BOTTOM_CUSTOM:String = "bcustom";
		public static const BOTTOM_CUSTOM_LIMITED:String = "bcustomLimit";
		
		public static const LEFT_CENTER:String = "lcenter";
		public static const LEFT_CUSTOM:String = "lcustom";
		public static const LEFT_CUSTOM_LIMITED:String = "lcustomLimit";
		
		public static const RIGHT_CENTER:String = "rcenter";
		public static const RIGHT_CUSTOM:String = "rcustom";
		public static const RIGHT_CUSTOM_LIMITED:String = "rcustomLimit";
		
		//default
		public static const CUSTOM:String = "custom";
		public static const CUSTOM_LIMITED:String = "customLimit";
	}
}