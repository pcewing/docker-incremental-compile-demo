workspace "MyApp"
   location "build"
   cppdialect "C++11"
   configurations { "Debug", "Release" }

project "MyApp"
   kind "ConsoleApp"
   language "C++"
   targetdir "build/bin/%{cfg.buildcfg}"

   files { "**.h", "**.cpp" }

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"
