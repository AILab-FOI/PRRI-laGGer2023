# Multiple PulseAudio Servers Possible

By: ChatGPT 4

---

Yes, it is possible to run multiple PulseAudio servers on a single system. However, it is not common practice and it is not recommended for typical usage because it can lead to more complex audio management and potential conflicts. 

In most cases, a single PulseAudio server is more than capable of handling all the audio needs of a system. Multiple servers would typically only be necessary in a complex audio setup where different users or applications require separate, distinct audio configurations.

To run multiple PulseAudio servers on a system, you would generally need to create separate PulseAudio configuration files for each server instance and then start each server with its own configuration file. Each server would also need to listen on a different socket or port to avoid conflicts.

Keep in mind, though, that this kind of setup can be quite complex and would typically require a solid understanding of PulseAudio and Linux audio systems in general. It's also important to consider that applications will only connect to one PulseAudio server at a time. To switch between different PulseAudio servers, applications would typically need to be restarted or their audio output redirected. 

In conclusion, while it's possible, running multiple PulseAudio servers on a single system is a relatively complex task that is typically not necessary for most users or applications.

---

Setting up multiple PulseAudio servers on a single system involves creating separate user accounts and running PulseAudio as a per-user session. Here's a general guide:

1. **Create new user accounts**: You'll need to create as many user accounts as the number of PulseAudio servers you want to run. For instance, if you want to run two servers, you might create users "pulse1" and "pulse2". You can create new users with the `adduser` command in Linux:

    ```bash
    sudo adduser pulse1
    sudo adduser pulse2
    ```

2. **Start PulseAudio server for each user**: You'll want to start a PulseAudio server for each user. The `su` command can be used to switch users, and `pulseaudio --start` can be used to start the server. 

    ```bash
    su -l pulse1 -c 'pulseaudio --start'
    su -l pulse2 -c 'pulseaudio --start'
    ```

3. **Configure applications to use the appropriate server**: This can be more complicated, as it involves configuring each application to use the appropriate PulseAudio server. This typically involves setting the `PULSE_SERVER` environment variable to the appropriate value before starting the application.

    ```bash
    PULSE_SERVER={pulse1_server} application1
    PULSE_SERVER={pulse2_server} application2
    ```
   Replace `{pulse1_server}` and `{pulse2_server}` with the actual names of your PulseAudio servers, and replace `application1` and `application2` with the actual names of your applications.

Remember, this is a general guide and might need adjustments based on your specific configuration and requirements. This type of setup can be complex, and it generally requires a good understanding of Linux user accounts, the PulseAudio system, and how your applications interact with the audio system. In most cases, it's easier and more efficient to run a single PulseAudio server and use it to manage all of your audio devices and applications.

---

Yes, PulseAudio allows you to control routing of audio streams to specific sinks (output devices). This involves moving the audio stream to the desired sink. Here are the general steps:

1. **List all your sinks** (output devices) and sink inputs (audio streams) by using the `pacmd list-sinks` and `pacmd list-sink-inputs` commands respectively. You'll need the sink and sink input index numbers from these lists for further operations.

2. **Move an audio stream** to a specific sink by using the `pacmd move-sink-input` command followed by the sink input index and the sink index. For instance, if you want to move sink input 1 to sink 2, you would use the command: `pacmd move-sink-input 1 2`.

3. **Repeat this process** for each audio stream, moving it to the desired sink.

You can also set up persistent routing so that certain applications always output to a specific sink. This is more complex and involves editing the PulseAudio configuration files, but there are plenty of online resources available to guide you through the process if you decide to go down this route.

Remember that each application can only play to one sink at a time. However, it's perfectly possible to have multiple applications each playing to a different sink, which seems to be what you're asking about.

It's also worth noting that PulseAudio can perform automatic routing based on policy (like which sink was used last, or based on type of audio content), but for more specific requirements manual routing might be necessary.

Please be aware that you need to have sufficient hardware resources to support multiple simultaneous audio streams. Every sink needs a corresponding physical output device (like a speaker, a headphone jack, or an HDMI output), unless it's a virtual sink.