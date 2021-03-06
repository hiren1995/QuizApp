//
//  ConstantValues.swift
//  QuizApp
//
//  Created by Apple on 12/05/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit


var userdefault = UserDefaults.standard

var isLogin = "isLogin"
var contactNoToVerify = "contactNoToVerify"
var userId = "userId"
var userToken = "userToken"
var userData = "userData"
var LoginMobileNo = "LoginMobileNo"
var LoginPassword = "LoginPassword"
var DeviceToken = "DeviceToken"
var DeviceId = "DeviceToken"
var TotalTimeOutDefault = "TotalTimeOutDefault"


var LoginParameters = "LoginParameters"

var baseUrl = "https://bulale.in/quiz/index.php/api/"
var signupAPI = "\(baseUrl)/user/user_register"
var signinAPI = "\(baseUrl)/user/user_login"
var verifyUserAPI = "\(baseUrl)/user/user_verify"
var quizListAPI = "\(baseUrl)/user/quiz_list"
var questionListAPI = "\(baseUrl)/user/quiz_question_list"
var quizJoinAPI = "\(baseUrl)/user/quiz_join"
var quizEndAPI = "\(baseUrl)/user/quiz_end"
var leaderBoardListAPI = "\(baseUrl)/user/leader_board_list"
var quizResultAPI = "\(baseUrl)/user/get_quiz_result"
var leaderBoardQuizListAPI = "\(baseUrl)/user/leaderboard_quiz_list"
var globalLeaderBoardAPI = "\(baseUrl)/user/global_quiz_result"
var aboutUsDetailsAPI = "\(baseUrl)/user/about_us_details"
var myQuizListAPI = "\(baseUrl)/user/my_quiz_list"
var myQuizResultAPI = "\(baseUrl)/user/my_quiz_result"
var resendOTPAPI = "\(baseUrl)/user/resend_otp"
var ForgetPasswordAPI = "\(baseUrl)/user/forgot_password"
