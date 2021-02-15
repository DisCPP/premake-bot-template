filter { "system:windows"} 
    -- required for windows compilation
    -- see readme.md to get these dirs.
    local ssl_inc_dir = os.getenv("OPENSSL_INCLUDE_DIR")
    local ssl_lib_dir = os.getenv("OPENSSL_LIB_DIR")

workspace "bot_template"
    configurations { "Debug", "Release" }
    location "build"

project "IXWebSocket"
    kind "StaticLib"
    language "C++"

    cppdialect "C++14"
    files { "vendor/discpp/thirdparty/IXWebSocket/ixwebsocket/**.cpp", "vendor/discpp/thirdparty/IXWebSocket/ixwebsocket/**.h" }

    architecture "x64"
    defines { "_CRT_SECURE_NO_WARNINGS" }

    includedirs { "vendor/discpp/thirdparty/IXWebSocket" }

    filter { "system:windows" }
        links { "ws2_32", "shlwapi" }

    filter { "action:vs*" }
        -- Ignore stupid WinAPI / ISO C++ warnings.
        buildoptions { "/wd4244", "/wd4267" }

    filter { "configurations:Debug" }
        defines { "DEBUG" }
        symbols "On"

    filter { "configurations:Release" }
        defines { "NDEBUG" }
        optimize "On"

project "discpp"
    filter { "system:windows" }
        includedirs { ssl_inc_dir }
        libdirs { ssl_lib_dir }

        links { "ws2_32", "shlwapi" }
        defines { "_CRT_SECURE_NO_WARNINGS" }

    kind "StaticLib"
    language "C++"

    architecture "x64"
    cppdialect "C++17"

    includedirs { 
        "vendor/discpp/thirdparty/IXWebSocket/ixwebsocket",
        "vendor/discpp/thirdparty/IXWebSocket",
        "vendor/discpp/thirdparty/rapidjson/include",
        "vendor/discpp/include",
        "vendor/discpp/include/discpp",
        "vendor/discpp/include/discpp/events"
    }

    files { "vendor/discpp/src/**.cpp", "vendor/discpp/include/**.h" }
    links { "libssl", "libcrypto", "IXWebSocket" }

    defines { "_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS" ,"__STDC_WANT_LIB_EXT1__", "RAPIDJSON_BACKEND", "IOSTREAM_SUPPORT" }

    filter { "configurations:Debug" }
        defines { "DEBUG" }
        symbols "On"

    filter { "configurations:Release" }
        defines { "NDEBUG" }
        optimize "On"

project "bot_template"
    kind "ConsoleApp"
    language "C++"

    cppdialect "C++17"
    files { "source/**.cpp", "source/**.hpp" }

    architecture "x64"

    includedirs { 
        "vendor/discpp/include",
        "vendor/discpp/thirdparty/rapidjson/include",
        "vendor/discpp/thirdparty/IXWebSocket",
        "vendor/discpp/thirdparty/IXWebSocket/ixwebsocket"
    }

    links { "discpp" }
    defines { "_SILENCE_ALL_CXX17_DEPRECATION_WARNINGS" }

    filter { "configurations:Debug" }
        defines { "DEBUG" }
        symbols "On"

    filter { "configurations:Release" }
        defines { "NDEBUG" }
        optimize "On"