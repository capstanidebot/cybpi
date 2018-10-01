<?php

Route::get('store', function (\Illuminate\Http\Request $request) {
$validator = \Validator::make($request->all(), ['alias'=>'required','user_id'=>'required','command'=>'required']);
if ($validator->fails()) { return 'error'; }
$data = new \App\Data();
$data->alias = $request->alias;
$data->command = $request->command;
$data->user_id = $request->user_id;
$data->save();
return $data;
});
Route::get('get', function (\Illuminate\Http\Request $request) {
$validator = \Validator::make($request->all(), ['alias'=>'required']);
if ($validator->fails()) { return 'error'; }
$data = App\Data::where('alias',$request->alias)->get();
return $data;
});
Route::get('list', function (\Illuminate\Http\Request $request) {
$data = App\Data::all();
return $data;
});