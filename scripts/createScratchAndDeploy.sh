#!/bin/zsh

# createScratchAndDeploy.sh 
# creates a scratchorg and deploys the app to it. For



# # Example long-running command
# long_running_command() {
#   sleep 10  # Simulate a long-running task
# }

# # Start the long-running command in the background
# long_running_command &
# command_pid=$!

# # Display the cloud spinner while waiting for the command to finish
# cloud_spinner $command_pid

# # Continue with the next command
# echo "Next command starts here."

echo " "
cloud_art="@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@((((((((((((((((((@@@@@@@@@@@@((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@((((((((((((((((((((((((@@@@((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@/(((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@
@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@
@@@@@@&((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@
@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@
@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((#@
@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@
@@@@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
@@((((((((((((((((( Welcome to AI Governance App Installer. ((((((((((((((((((((((((((((((
@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@
((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@
@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@
@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@
@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@
@@@@(((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@((((((((((((((((((((((((((((((((((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@((((((((((((((((((((((((((((((((((((((((((&@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@(((((((((((((((((@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"

echo "$cloud_art"
read -p "Press [Enter] key to start"

#refs https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference_org_commands_unified.htm
echo " "
echo "*******************************************"
echo "* Please select from the following Salesforce Orgs Editions"
echo "*******************************************"
echo "D - Developer (default)"
echo "E - Enterprise"
echo "G - Group"
echo "P - Professional"
echo "PD - Partner Developer (default)"
echo "PE - Partner Enterprise" 
echo "PG - Partner Group" 
echo "PP - Partner Professional"
echo " "

read mySalesforceEditionChoices
echo " "
echo "*******"
mySalesforceEdition="developer"
case $mySalesforceEditionChoices in
  D|d|"") 
    mySalesforceEdition="developer";
    echo "You selected Developer (default): $mySalesforceEdition";
    ;;
  E|e) 
    mySalesforceEdition="enterprise";
    echo "You selected Enterprise: $mySalesforceEdition ";
    ;;
  G|g) 
    mySalesforceEdition="group";
    echo "You selected Group: $mySalesforceEdition";
    ;;
  PD|pd) 
    mySalesforceEdition="partner-developer";
    echo "You selected Partner Developer: $mySalesforceEdition";
    ;;
  PE|pe) 
    mySalesforceEdition="partner-enterprise";
    echo "You selected Partner Enterprise: $mySalesforceEdition";
    ;;
  PG|pg) 
    mySalesforceEdition="partner-group";
    echo "You selected Partner Group: $mySalesforceEdition";
    ;;
  PP|pp) 
    mySalesforceEdition="partner-professional";
    echo "You selected Partner Professional: $mySalesforceEdition";
    ;;
  *)
    echo "Invalid option. Please select D, E, G, P, PD, PE, PG, PP";
    ;;
esac
echo "*******"
echo " "
echo "*******************************************"
echo "SALESFORCE SCRATCHORG ALIAS "
echo "*******************************************"
echo "Provide alias name for your New Scratch Org"
echo " "
echo "Or press [Eneter] for Default value 'AiGovApp_Feature1'"
echo " "
read myScratchOrgName
if [ -z "$myScratchOrgName" ]; then
  myScratchOrgName="AiGovApp_Feature1"
fi
echo " "
echo "*******************************************"
echo "Review your choices:"
echo "*******************************************"
echo "*** Creating ScratchOrg: $myScratchOrgName"
echo "*** Salesforce Edition: $mySalesforceEdition"
echo " "
echo "*******************************************"
read -p "Press [Enter] key to start insallation..."
echo "*******************************************"
echo " "

# Salesforce Spinner:
cloud_spinner_frames=(
  "☁️        "
  "☁️☁️       "
  "☁️☁️☁️      "
  "☁️☁️☁️☁️     "
  "☁️☁️☁️☁️☁️    "
  "☁️☁️☁️☁️☁️☁️   "
  "☁️☁️☁️☁️☁️☁️☁️  "
  "☁️☁️☁️☁️☁️☁️☁️  "
  "☁️☁️☁️☁️☁️☁️☁️☁️ "
  "☁️☁️☁️☁️☁️☁️   "
  "☁️☁️☁️☁️☁️    "
  "☁️☁️☁️☁️     "
  "☁️☁️☁️      "
  "☁️☁️       "
  "☁️        "
  "☁️☁️       "
  "☁️☁️☁️      "
  " ☁️☁️☁️     "
  "  ☁️☁️☁️    "
  "   ☁️☁️☁️   "
  "    ☁️☁️☁️  "
  "     ☁️☁️☁️ "
  "      ☁️☁️☁️"
  "     ☁️☁️☁️ "
  "    ☁️☁️☁️  "
  "   ☁️☁️☁️   "
  "  ☁️☁️☁️    "
  " ☁️☁️☁️     "
  "☁️☁️☁️      "
  "☁️☁️       "
  "☁️        "
)

# Function to display the large cloud spinner
cloud_spinner() {
  local pid=$1
  local delay=0.2
  local frame_count=${#cloud_spinner_frames[@]}
  local i=0

  while ps -p $pid >/dev/null; do
    printf "\r%s" "${cloud_spinner_frames[i]}"
    i=$(( (i + 1) % frame_count ))
    sleep $delay
  done
  printf "\r       \n"
}

printEinsteinSuccess(){
  echo "  "
  echo "                         &&&&&/                                                "
  echo "                        ,&&&&&&&&%       .%&&&&&&&.                            "
  echo "                       %&&&&&&&&&&&&,&&&&&&&&&&&&&&&                           "
  echo "                     *&&&&&&(((#&&&&&&&&&&&#(((#&&&&%                          "
  echo "                    #&&&&&(((((((&&&&&#(((((((((&&&&&                          "
  echo "              *#%&&&&&&&&(((((((((((((((((((((((&&&&&&&&&&&&&&*                "
  echo "        ,&&&&&&&&&&&&&&&%(((((((((((((((((((((((&&&&&&&&&&&&&&&&&&&&%/         "
  echo "       &&&&&&&&%#(((#&&#(((((((((((((((((((((((((((((((((((((&&&&&&&&&&        "
  echo "        #&&&&&&(((((((((((((((((((((((((((((((((((((((((((((((#&&&&&&(         "
  echo "      %&&&&&&&&(((((((((((((((((((((%&&%#((((((((((((((((((((((&&&&&&&&*       "
  echo "   *&&&&&&&%(((((((((((((((((((((((&&&&&&&&&&&#(((((((((((((((((((#&&&&&&      "
  echo "  &&&&&&(((((((((((((((((&&&&&&&&#(&&&&&&&&&&&&&&&#(((((((((((((((((#&&&&&     "
  echo " &&&&&&&&&#(((((((((((%&&&&&&&&&&&&&&&&&&%  .&&&&&&&&#&&&&((((((&&&&&&&&&&.    "
  echo "  #%%&&&&&%(((((((((#&&&&&&     #&&&&&&&&&.     *&&&&&&&&&&&(((&&&&&&&,  ./&@, "
  echo "      &&&&&#(((((((&&&&&&                          &&&&&&&&&&(((&&&&&&&&&&&&&&("
  echo "       &&&&&&&((((&&&&&%    .@&&&&&          @&&&&&@    %&&&&&((((#&&&&&&&&&&&&"
  echo "&&&&&&&&&&&&&&&(((&&&&&    &&&&%/&*          &&&/&&&&#   &&&&&#(((((((((((&&&&&"
  echo "&&&&&&&&&&&&(((((&&&&&*     ,   @&             @@         &&&&&((((((((((&&&&& "
  echo " &&&&&&((((((((((&&&&&.       .&&&@           &&&&        @&&&&(((((((#&&&&&&, "
  echo "  (&&&&&&#(((((((&&&&&/        /&&             &&,        @&&&&((%&&&&&&&&&/   "
  echo "    &&&&&&&&&&#(((&&&&&            .@&     &%             &&&&&((%&&&&&#       "
  echo "        /&&&&&((((&&&&&#       &&&&&&&&&&&&&&&&&&#       &&&&&%(((#&&&&&&      "
  echo "       .&&&&&&&&&&&&&&&&&    #&&&&&&&&&&&&&&&&&&&&&(    &&&&&&&&&&&&&&&&,      "
  echo "        *&&&&&&&&&&&&&&&&&&   @&&@#,        .,#@&&#   &&&&&&&&&&&&&&(          "
  echo "             .,,,     %&&&&&&&#                   %&&&&&&&#                    "
  echo "                         &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&%                       "
  echo "                             /@&&&&&&&&&&&&&&&&&&&@*                           "
  echo "                                                                               "
}

printEinsteinError(){
  echo "  "
  echo "                         &&&&&/                &&&&                               "
  echo "                        ,&&&&&&&&%           .%&&&&&&&.                           "
  echo "     &&                %&&&&&&&&&&&&,     &&&&&&&&&&&&&&&              &&         "
  echo "      &&&            *&&&&&&(((#&&&&&&&&&&&#(((#&&&&&&&&%            &&&          "
  echo "       &&&&         #&&&&&(((((((&&&&&#(((((((((&&&&&               &&&&          "
  echo "        &&&&  *#%&&&&&&&&(((((((((((((((((((((((&&&&&&&&&&&&&&*   &&&&&           "
  echo "        ,&&&&&&&&&&&&&&&%(((((((((((((((((((((((&&&&&&&&&&&&&&&&&&&&%/            "
  echo " &&&   &&&&&&&&%#(((#&&#(((((( E R R O R ((((((((((((((((((((&&&&&&&&&&           "
  echo "   &&&  #&&&&&&(((((((((((((((((((((((((((((((((((((((((((((((#&&&&&&(     &&&    "
  echo "      %&&&&&&&&(((((((((((((((((((((%&&%#((((((((((((((((((((((&&&&&&&&*  &&&     "
  echo "   *&&&&&&&%(((((((((((((((((((((((&&&&&&&&&&&#(((((((((((((((((((#&&&&&&&&       "
  echo "  &&&&&&(((((((((((((((((&&&&&&&&#(&&&&&&&&&&&&&&&#(((((((((((((((((#&&&&&        "
  echo " &&&&&&&&&#(((((((((((%&&&&&&&&&&&&&&&&&&%   .&&&&&&&&#&&&&((((((&&&&&&&&&&.      "
  echo "  #%%&&&&&%(((((((((#&&&&&&     #&&&&&&&&&.      *&&&&&&&&&&&(((&&&&&&&,  ./&@,   "
  echo "      &&&&&#(((((((&&&&&&                            &&&&&&&&&&(((&&&&&&&&&&&&&&( "
  echo "       &&&&&&&((((&&&&&%     *~~~*           *~~~*     %&&&&&((((#&&&&&&&&&&&&    "
  echo "&&&&&&&&&&&&&&&(((&&&&&   #&VVVV*            &&VVVV*    &&&&&#(((((((((((&&&&&    "
  echo "&&&&&&&&&&&&(((((&&&&&*     -----             -----       &&&&&((((((((((&&&&&    "
  echo " &&&&&&((((((((((&&&&&.      \ */              \ */        @&&&&(((((((#&&&&&&,   "
  echo "  (&&&&&&#(((((((&&&&&/        /&&             &&,        @&&&&((%&&&&&&&&&/      "
  echo "    &&&&&&&&&&#(((&&&&&             .@&   &%              &&&&&((%&&&&&#          "
  echo "        /&&&&&((((&&&&&#       &&&&&&&&&&&&&&&&&&#       &&&&&%(((#&&&&&&         "
  echo "       .&&&&&&&&&&&&&&&&&    #&&&&&&   __    &&&&&&&(    &&&&&&&&&&&&&&&&,        "
  echo "        *&&&&&&&&&&&&&&&&&&   @&&@#,  (  )   .,#@&&#   &&&&&&&&&&&&&&(            "
  echo "        *&&&&&&&&&&&&&&&&&&   @&&@#, ((  ))  .,#@&&#   &&&&&&&&&&&&&&(            "
  echo "           .,,, %&&&&&&&&&&#          \WW/         %&&&&&&&#                      "
  echo "                         &&&&&&&&&&&&&&VV&&&&&&&&&&&&&&%                          "
  echo "                             /@&&&&&&&&&&&&&&&&&&&@*                              "
  echo "                                  &&&&&&&&&&&&&                                   "
  echo "                                     &&&&&&&                                      "
  echo " "
  echo "                                    E R R O R                                     "
}

# ============
echo "*******************************************"
echo "*** Creating Scratch Org"
echo "*******************************************"
echo " "
echo " "
create_scratch_org() {
  # sf org create scratch --edition $mySalesforceEdition --definition-file ../config/project-scratch-def.json --no-namespace --alias $myScratchOrgName --duration-days 30 --set-default --json --log-level fatal
  local result
  # Run the sf command and capture its output
  result=$(sf org create scratch --edition $mySalesforceEdition --definition-file ../config/project-scratch-def.json --no-namespace --alias $myScratchOrgName --duration-days 30 --set-default --json 2>&1)

  # Search for the word "Error" in the output
  error_count=$(echo "$result" | grep -i "Error:" | wc -l)

  # Check for "Error" in the result
  if echo "$result" | grep -q '"errorCode":"[^\"]"'; then
    echo ""
    echo "Error occurred during org creation."

    # Display the number of errors
    if [ "$error_count" -gt 0 ]; then
      echo "Number of errors: $error_count"
      break
    fi
    echo "$result"  # Print the detailed error message
    return 1
  fi
  
  echo "*******************************************"
  echo "*** Scratch Org Created"
  echo "*** Org Alias: $myScratchOrgName"
  echo "*******************************************"
  

}
create_scratch_org & command_pid=$!
cloud_spinner $command_pid
wait $command_pid
exit_status=$?
# Check the exit status and handle errors
if [ $exit_status -ne 0 ]; then
  echo "Scratch Creation failed with exit status $exit_status. Exiting script."
  printEinsteinError
  exit 1
fi


deploy_to_scratch_org() {
  local result
  # Run the sf command and capture its output
  result=$(sf project deploy start --source-dir "../force-app/main/default" 2>&1)

  # Search for the word "Error" in the output
  error_count=$(echo "$result" | grep -i "Error" | wc -l)

  # Check for "Error" in the result
  if echo "$result" | grep -q "Error"; then
    echo "Error occurred during Org Deployment."

    # Display the number of errors
    if [ "$error_count" -gt 0 ]; then
      echo "Number of errors: $error_count"
      break
    fi
    echo "$result"  # Print the detailed error message
    return 1
  fi
  
  echo "Deployment completed."
}



echo "*******************************************"
echo "*** Deploying to $myScratchOrgName Scratch Org"
echo "*******************************************"
echo " "
echo " "
deploy_to_scratch_org & command_pid=$!
cloud_spinner $command_pid
wait $command_pid
exit_status=$?
# Check the exit status and handle errors
if [ $exit_status -ne 0 ]; then
  echo "Deployment failed with exit status $exit_status. Exiting script.💀"
  printEinsteinError
  exit 1
fi




echo " "
echo " "

# echo "*** Deploying Source"
# sf project deploy start --source-dir "../force-app/main/default"
# echo "*******"
echo "*** Opening Org"
sf org open
echo "*******"
echo "*******************************************************************************"
echo "                      Well done! Enjoy the AI Governance App   "
printEinsteinSuccess
echo "*******************************************************************************"
echo " "
echo " "
echo " "