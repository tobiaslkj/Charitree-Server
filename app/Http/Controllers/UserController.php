<?php
namespace App\Http\Controllers;

use App\Models\User;
use App\Models\Address;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\CampaignManager;
use Symfony\Component\HttpFoundation\Response;
use Illuminate\Validation\Rule;
use App\Services\Contracts\IUserService;

class UserController extends Controller
{
    protected $userService; //IUserRespository type
    /**
     * Create a new controller instance.
     *
     * @return void
     */ 
    public function __construct(IUserService $userService)
    {
        $this->userService = $userService;
    }

    public function register(Request $request)
    {   
        $validator = Validator::make($request->all(), User::$rules['register']);
        
        if($validator->fails()){
            $errors = $validator->errors()->toArray();
            $errors['message'] = "Unable to process";
            //$errors->add("message", "Unable to process parameters.");
            return response()->json(["status"=>"0", "errors"=> $errors], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        if($this->userService->create($request->all())){
            return response()->json(['status' => '1', 'message' => 'User created.'], Response::HTTP_CREATED);
        }
        else{
           return response()->json(['status' => '0', 'message' => 'Something went wrong']);
        }
    }

    public function editUser(Request $request, User $user){
        /**
         * How to find a better way of passing $user->id to the static array. 
         * Current work around.
         */
        $validator = Validator::make($request->all(), [
            'email'=>'required|email|unique:User,email,'.$user->id
        ]);

        if($validator->fails()){
            $errors = $validator->errors()->toArray();
            $errors["message"] = "Unable to process parameters.";
            return response()->json(["status"=>"0", "errors"=> $errors], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        if($this->userService->edit($request->all(), $user)){
            return response()->json(['status'=>'1','message'=>'User updated.'],201);
        }

        else{
            $errors = array();
            $errors["message"]="Something went wrong.";
            return response()->json(['status'=>'0','errors'=>$errors]);
        }
    }

    public function registerAsCampaignManager(Request $request, User $user){

        $validator = Validator::make($request->all(), CampaignManager::$rules['register']);
        
        if($validator->fails()){
            $errors = $validator->errors()->toArray();
            $errors["message"] = "Unable to process parameters.";
            return response()->json(["status"=>"0", "errors"=> $errors], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        if(!is_null($user->campaignManager)){
            $errors["message"] = "Alreay a campaign manager!";
            return response()->json(['status'=>'0', 'message'=>$errors], Response::HTTP_CONFLICT);
        }


        $cm = new CampaignManager($request->all());
        $cm->cid = $user->id;
        $user->campaignManager()->save($cm);
        $user->refresh();
        return response()->json(['status' => '1', 'message' => 'Campaign Manager Created'], Response::HTTP_CREATED);

    }

    public function getCurrentCampaignManagerDetails(User $user){
        $cm = $user->campaignManager;
        return response()->json(['status' => '1', 'campaign_manager' => $cm], Response::HTTP_OK);
    }

    public function addAddresses(Request $request, User $user){
        $validator = Validator::make($request->all(), Address::$rules['create']);
        
        if($validator->fails()){
            $errors = $validator->errors()->toArray();
            $errors["message"] = "Unable to process parameters.";
            return response()->json(["status"=>"0", "errors"=> $errors], Response::HTTP_UNPROCESSABLE_ENTITY);
        }

        $addressesInputs = $request->input('addresses');
        $addresses = $this->userService->addUserAddress($addressesInputs, $user);

        return response()->json(['status'=>1, 'message'=>'Addresses created', 'addresses'=>$addresses], Response::HTTP_CREATED);
    }

    public function getUserAddresses(User $user){
        $addresses = $this->userService->getUserAddresses($user);
        if(is_null($addresses)){
            $errors['message'] = "No addresses found";
            return response()->json(["status"=>0, "errors"=>$errors], Response::HTTP_NOT_FOUND);
        }
        return response()->json(['status'=>1, "message"=>"User's addresses", "addresses"=>$addresses]);
    }
}
