<?php
namespace App;
use Illuminate\Database\Eloquent\Model;
class Data extends Model
{
	protected $fillable = ['alias', 'command', 'user_id'];
}