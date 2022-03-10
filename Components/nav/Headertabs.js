import React,{useContext} from 'react';
import { View,TouchableOpacity,Text,SafeAreaView } from 'react-native';
import { AuthContext } from '../../context/auth';
import FontAwesome5 from "react-native-vector-icons/FontAwesome5";
import AsyncStorage from '@react-native-async-storage/async-storage';

function Headertabs() {

    const [state,setState] = useContext(AuthContext);
    const signout = async()=>{
        setState({token:"",user:null});
        await AsyncStorage.removeItem("@auth");
    }    

  return (
    <SafeAreaView>
        <TouchableOpacity onPress={signout}>
            <FontAwesome5 name="sign-out-alt" size={25} color="red"/>
        </TouchableOpacity>
    </SafeAreaView>
  )
}

export default Headertabs