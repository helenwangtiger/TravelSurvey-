==============
TravelSurvey-
==============
This app is compatiable with iOS 6 and iOS7 on iPhone 4 or higer except iPhone 6 or iPhone 6 Plus. The orderly names of the 
.m files represent the tab bars respectively in the app. 

Data Structure of Storage and Upload
---------------------------
All the data from the user's input are saved into a multi-demensional array,"answerContent[answerChoices][answerType][keyOfDic]."
The arrays are structured in this way because the answers to the questions are classified as multiple-choice selection and text 
input. The multiple-choice selection displays the answer choices that are organized into the array, “answerChoices.”The 
“answerType” in the array is used to define what kind of interface will be shown on the screen. The "answerType" is given three 
values 1, 2, and 3, to flag the interface display. Number 1 defines the answer as a text input, and a text field 
with a standard keyboard will be generated. In this case, the array “answerChoices” is empty, so it is assigned a space as a 
placeholder. Number 2 classifies a multiple-choice selection, and a picker view with answer choices will be shown on the screen. 
Number 3 refers to a digital-only text input, and a text field with a digital keyboard will appear. “keyOfDic” is used to assign 
a key to each question so that the answer to the question can be saved as a value in a dictionary.  “answerContent” is 
dynamically created with questions, before it is set to NULL, each “answerContent” is added into the other multi-dimensional 
array called “categoryArray” for use in different data categories. 

The answers are eventually stored into a property list file (plist) organized as a dictionary structure. The answers are saved as
a value pairing with an identifying key from the last index “keyOfDic” in “answerContent”.  The one-time input answers are 
immediately written into a plist.The trip plist, which is named tripName.plist,is dynamically and individually created so that 
each trip information can match the corresponding trip.  

The method of uploading data to the database is by making an http request to the PHP web service.  At the time when the PHP file 
receives the request, the PHP file starts to process SQL query and transfer the data to the database. The http request is 
produced by a string that is structured by the server address, sample number, action type, keys, and values. Participants are 
allowed to re-submit data if they edit the data. On the server side, if the sending sample number cannot be found in the 
database table, the PHP file executes SQL insert query.Otherwise, it executes an update query. 


