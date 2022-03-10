import React, { useState,useContext } from "react";
import { Text, View, ScrollView } from "react-native";
import SubmitButton from "../Components/Auth/SubmitButton";
import UserInput from "../Components/Auth/UserInput";
import CircleLogo from "../Components/Auth/CircleLogo";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";
import AsyncStorage from "@react-native-async-storage/async-storage";


import axios from "axios";
import { AuthContext } from "../context/auth";

const Signin = ({ navigation }) => {
  const [email, setEmail] = useState("apple@gmail.com");
  const [password, setPassword] = useState("apple123");
  const [loading, setLoading] = useState(false);

  //context
  const [state,setState] = useContext(AuthContext)

  const handleSubmit = async () => {
    setLoading(true);
    if (!email || !password) {
      alert("All fields are required");
      setLoading(false);
      console.log(email, password);
      return;
    }
    try {
      const { data } = await axios.post(`/signin`, {
        email,
        password,
      });
      if (data.error) {
        alert(data.error);
        setLoading(false);
      } else {
        // save in context 
        setState(data)
        // save response in async storage
        await AsyncStorage.setItem("@auth", JSON.stringify(data));
        setLoading(false);
        alert("Signin success");
        navigation.navigate("Home")
      }
    } catch (error) {
      console.log(error);
    }
  };

  const loadFromAsyncStorage = async() => {
    let data = await AsyncStorage.getItem("@auth")
    console.log("Async Storage data",data)
  }
  loadFromAsyncStorage();

  return (
    <KeyboardAwareScrollView>
      <View style={{ flex: 1, justifyContent: "center" }}>
        <CircleLogo />
        <Text
          style={{
            fontSize: 24,
            color: "#333",
            textAlign: "center",
            marginVertical: 25,
          }}
        >
          Please Sign in
        </Text>
        <UserInput
          value={email}
          setValue={setEmail}
          autoCompleteType="email"
          keyboardType="email-address"
          name="Email"
        />
        <UserInput
          value={password}
          setValue={setPassword}
          secureTextEntry={true}
          autoCompleteType="password"
          name="Password"
        />

        <SubmitButton
          handleSubmit={handleSubmit}
          loading={loading}
          title="Sign in"
        />

        <Text
          style={{
            textAlign: "center",
            fontSize: 12,
            color: "black",
          }}
        >
          Not yet registered?{" "}
          <Text
            onPress={() => navigation.navigate("Signup")}
            style={{ fontSize: 12, color: "red" }}
          >
            Sign Up
          </Text>
        </Text>
        <Text
          style={{
            marginVertical: 25,
            textAlign: "center",
            fontSize: 12,
            color: "orange",
          }}
        >
          Forgot Password?
        </Text>
      </View>
    </KeyboardAwareScrollView>
  );
};

export default Signin;
