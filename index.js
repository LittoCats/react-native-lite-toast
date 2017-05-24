import ReactNative, {
  Platform,
} from 'react-native'

const Native = Platform.OS == 'ios' ? ReactNative.NativeModules.ToastIOS : ReactNative.ToastAndroid;

class Toast {
  SHORT = Native.SHORT;
  LONG = Native.LONG;
  TOP = Native.TOP;
  CENTER = Native.CENTER;
  BOTTOM = Native.BOTTOM;
  

  show(message, duration, gravity) {
    this.showWithGravity(message, duration, gravity);
  }

  showWithGravity(message, duration, gravity) {
    if (typeof message != 'string') {
      message = JSON.stringify(message, null, 2);
    }
    if (duration != this.LONG) duration = this.SHORT;

    if (gravity != this.TOP && gravity != this.CENTER) {
      gravity = this.BOTTOM;
    }

    Native.showWithGravity(message, duration, gravity);
  }
}

export default new Toast