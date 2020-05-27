# fixed_rate_timer

This is a pretty straightforward plugin that executes a repeating action. It works on the background on Android, as a Service, and even without a service on iOS.

## Android-specific settings

Please add

```
<service android:enabled="true" android:name="com.gildaswise.fixed_rate_timer.FixedRateTimerService" />
```

to your app's `AndroidManifest.xml` file so the service is properly enabled.
