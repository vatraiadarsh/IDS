import React, { useState,useContext } from "react";
import { Text, View, ScrollView } from "react-native";
import SubmitButton from "../Components/Auth/SubmitButton";
import UserInput from "../Components/Auth/UserInput";
import AsyncStorage from "@react-native-async-storage/async-storage";

import axios from "axios";

import CircleLogo from "../Components/Auth/CircleLogo";
import { KeyboardAwareScrollView } from "react-native-keyboard-aware-scroll-view";
import { AuthContext } from "../context/auth";

const Signup = ({ navigation }) => {
  const [name, setName] = useState("adarsha");
  const [email, setEmail] = useState("adarsh@gmail.com");
  const [password, setPassword] = useState("ajsdjlak");
  const [loading, setLoading] = useState(false);

  //context
  const [state, setState] = useContext(AuthContext);

  const handleSubmit = async () => {
    setLoading(true);
    if (!name || !email || !password) {
      alert("All fields are required");
      setLoading(false);

      return;
    }
    try {
      const { data } = await axios.post(`/signup`, {
        name,
        email,
        password,
      });
      if (data.error) {
        alert(data.error);
        setLoading(false);
      } else {
        // saving in context
        //context
        setState(data);

        // save response in async storage
        await AsyncStorage.setItem("@auth", JSON.stringify(data));
        setLoading(false);
        alert("Sign up successful");
        navigation.navigate("Home")
      }
    } catch (error) {
      alert("signup failed try again");
      console.log(error);
    }
  };

  return (
    <KeyboardAwareScrollView>
      <View style={{ flex: 1, justifyContent: "center" }}>
        <CircleLogo />
        <Text
          style={{
            fontSize: 24,
            color: "#333",
            textAlign: "center",
          }}
        >
          Please Sign up
        </Text>
        <UserInput
          value={name}
          setValue={setName}
          autoCorrect={false}
          autoCapitalize="words"
          name="Name"
        />
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
          title="Sign up"
        />

        <Text
          style={{
            textAlign: "center",
            fontSize: 12,
            color: "black",
          }}
        >
          Already Joined?{" "}
          <Text
            onPress={() => navigation.navigate("Signin")}
            style={{ fontSize: 12, color: "red" }}
          >
            Sign In
          </Text>
        </Text>
      </View>
    </KeyboardAwareScrollView>
  );
};

export default Signup;
