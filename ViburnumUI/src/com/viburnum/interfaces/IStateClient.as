package com.viburnum.interfaces
{
    public interface IStateClient
    {
        function get currentState():String;
        function set currentState(value:String):void;
    }
}