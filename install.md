# Running an LLM Locally

This setup uses 3 major components so that we can easily interface our LLMs

1. **llama.cpp** an open source library that allows us to perform **inference** on various large language models locally on our devices. The nice thing about this library is that we can directly download and run llms using `hugging face` models. Moreover, it has a built in HTTP server that is compatible with the `OpenAI API` that can be used to serve local models and easily connect them to existing clients. ([github repo](https://github.com/ggerganov/llama.cpp?tab=readme-ov-file))
2. **hugging face**: I think this will be the main platform from which we download pretrained weights for our llms. It is also possible to get the "official weights" for llama from Meta using an application form.
3. **ChatUI (TODO)**: a cool open source ui that allows us to "chat" with our LLM as we would with chatgpt. If you don't like this choice you can choose any client that is compatible with the `OpenAI API`. I still havent set it up properly this is kinda a todo still.

This guide will explain what is running in the provided scripts. If you have any issues just tell me. I will have tested them at least on an `M3 Max Macbook` and `Ubuntu 24.04.1 LTS`. I plan on testing it later on `Windows 10`.
## Installing and Running `llama.cpp`

This is the core utility that you use to run and install models. 
The following guide outlines some installation instructions. If you have a linux device or a Apple Silicon Macbook you can just use the provided scripts.

###  Linux

This guide is for linux users in the team. This setup was tested on `Ubuntu 24.04.1 LTS`. If you have any questions feel free to send me a whatsapp message.



This section outlines how the script runs and install `llama.cpp`. 

The first script `check_dependencies.sh` will check your system and tell you what you need to install before running the second script `install_llm_linux.sh`. 


It is not strictly necessary to build `llama.cpp` from source, however I would only recommend it for apple Silicon macbooks. From my understanding the default binaries lack gpu support (by design).</br>
It only takes about 30 mins to compile so it is definately worth it. 
These are the prerequisites for installing `llama.cp`:

1. **git:** Necessary for downloading all the repos
2. **CMAKE:** It is also possible to use `make` but then you are on your own for now
3. **curl:** you are likely to have curl already installed. However you also need the developer kit in order to compile. This is necessary if we want to download models from `huggingface_hub`.
4. **nvidia toolkit (optional)** For now this script only supports nvidia GPUs. If you don't have one then it will fallback onto installing `llama.cpp` for CPU.</br> In the case you just want to use your cpu can also use high performance linear algegra libraries such as `BLAS`. This is not supported by the installation script.

The script will also ask you if you want to add the `llama-cli` to your `$PATH` environment variable for global use. Otherwise you will have to be within the `.../path/to/llama.cpp/build/bin/` to run any command involving the LLM.




### MacOs

The setup is very similar to linux the only difference is that you can you can just use the default settings and you don't have to choose options depending on your system. 

**Note:** `OpenMp` is not supported by the default installation of `clang`. I personally don't think this will have too much of an impact on performance since the models get run on the GPU throught apple's "metal" framework. 

**Note:** On MacOs `gcc` is just a symbolic link to the xcode tools `clang` if you want "real gcc" you can install it using brew.




### Windows

DO NOT USE THE SCRIPT ON WINDOWS. I DON'T KNOW WHAT IT WILL DO. 

For windows I reccomend using the docker images already provided. You should choose the docker images according to your system. You can find full information on this [here](https://github.com/ggerganov/llama.cpp/blob/master/docs/docker.md). I'm sorry I don't have a windows pc to work on for now...

## Running and interacting with a model

Here are some instructions on how I used `llama.cpp` to install and run models locally. There are 1000s of different models you can choose and download from huggingface.
### Hugging Face Model

When I was messing around I found the following model on a [reddit post](https://www.reddit.com/r/LocalLLaMA/comments/1c9iawc/is_there_any_idiot_guide_to_running_local_llama/). It is quite nice and can be found [here](https://huggingface.co/QuantFactory/Meta-Llama-3-8B-Instruct-GGUF). It is simply a compressed version of the Meta 8B parameter LLAMA model. 

The script installs it as follows (using the code provided by hugging face).

```console
$ cd `.../path/to/llama.cpp/build/bin/` 
$
$ ./llama-cli \
$           --hf-repo "QuantFactory/Meta-Llama-3-8B-Instruct-GGUF" \
$           --hf-file Meta-Llama-3-8B-Instruct.Q2_K.gguf \
$           -p "You are a helpful assistant" \
$           --conversation
``` 

The code above gets generated when you press the *Use this model* dropdown on the top right corner of the repo. Not all pretrained models from hugging face are compatible with `llama.cpp`. Luckily we can convert any model on huggingface_hub into a compatible format using this tool [here](https://github.com/akx/ggify).

At this point you can interact with it locally by sending it messages in the terminal.

### Running a Server

If you want to interact a model in a more user friendly format you can install any of the hundreds of clients. 

The default client that comes with `llama.cpp` one is also okay you can start it as follows

```
$ ./llama-server -m ~/.cache/llama.cpp/Meta-Llama-3-8B-Instruct.Q2_K.gguf --port 8080

```

You can then open your browser at http://127.0.0.1:8080/ to start a conversation. The current settings make the chatbot quite annoying but on my rtx 3080 it seems just as fast as chatgpt.


## Troubleshooting and observations
Note: kiling the server doesn't seem to kill the llama-cli process in the background. 

Note: unless specified in the build flags hugging face models are cached in `~/.cache/llama.cpp` on linux and in `/Users/<username>/Libraries/Caches/llama.cpp`. The script doesn't give any option for adding this yet