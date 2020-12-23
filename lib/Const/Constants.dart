// Api related
const apiBaseURL = "https://tamilrise.herokuapp.com";

const API_MEMBERSHIP_TYPE = apiBaseURL + "/membershiptype/";
const API_MEMBERSHIP_CLASSIFICATION = apiBaseURL + "/membershipclass/";
const API_REGISTER = apiBaseURL + "/member/register1";
const API_REGISTER_PAYMENT = apiBaseURL + "/memberpayment/add";
const API_LOGIN = apiBaseURL + "/member/login1";
const API_MOBILE_LOGIN = apiBaseURL + "/member/login2?Mobile=";
const API_EVENTS_VIEW = apiBaseURL + "/events/aggregation";
const API_PROFILE_VIEW = apiBaseURL + "/member/fetchdata1?Mobile=";
const API_UPDATE_VIEW = apiBaseURL + "/member/update?id=";
const API_PROFILE_COUNTRY = apiBaseURL + "/country/";
const API_PROFILE_STATE = apiBaseURL + "/state/fetchBycountry?Country=";
const API_PROFILE_REGION = apiBaseURL + "/region/fetchBystate?State=";
const API_PROFILE_DISTRICT = apiBaseURL + "/district/fetchBycity?region=";
const API_PROFILE_CITY = apiBaseURL + "/city/fetchBycity?district=";
const API_PROFILE_INTERESTS = apiBaseURL + "/interests/get";
const API_EVENT_AGENDA = apiBaseURL + "/agenda/fetchByevenid?event=";
const API_EVENT_AGENDA_FIRST = apiBaseURL + "/agenda/fetchByevendate?event=";
const API_EVENT_AGENDA_TRACK = apiBaseURL + "/tracker/fetchByevenid?Event=";
const API_GET_CHAPTER = apiBaseURL + "/chapter/fetchbydistrict?district=";
const API_CHAPTER_MEMBER = apiBaseURL + "/member/fetchdatabychapter?Chapter=";

///////////   CHAT API  //////////////
const API_GET_CHAT_USERS = apiBaseURL + "/member/";
