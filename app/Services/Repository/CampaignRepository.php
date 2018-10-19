<?php
namespace App\Services\Repository;

use App\Contracts\Repository\ICampaignRepository;
use App\Models\User;
use App\Models\Session;
use App\Contracts\IAuthenticate;
use App\Models\Campaign;
use App\Models\CampaignManager;
use Illuminate\Container\Container;


class CampaignRepository implements ICampaignRepository{

    public function __construct()
    {
    }

    
    public function create(array $array){
        $app = Container::getInstance();
        $user = $app->make(User::class);
        $cm = $user->campaignManager;
        $campaign = new Campaign();
        $campaign->name = $array['name'];
        $campaign->start_date = $array['start_date'];
        $campaign->end_date = $array['end_date'];
        $cm->campaigns()->save($campaign);

        $campaign->items()->sync($array['accepted_items']);
    }
    
    public function edit(array $array){
        
    }

    public function find($id){
        return Campaign::find($id);
    }
}