# 设置 Codegen 生成目录，指定 generated 目录路径
set(rnoh_jverification_react_native_generated_dir "${CMAKE_CURRENT_SOURCE_DIR}/generated")
file(GLOB_RECURSE rnoh_jverification_react_native_generated_SRC "${rnoh_jverification_react_native_generated_dir}/**/*.cpp")

# 查找当前目录下的所有 .cpp 文件，并将其存储到变量 rnoh_calculator_SRC 中
# CONFIGURE_DEPENDS 表示如果这些文件被修改，CMake 会重新配置
file(GLOB rnoh_jverification_react_native_SRC CONFIGURE_DEPENDS *.cpp)

# 创建一个共享库 rnoh_centered_text，包含两部分：rnoh_centered_text_SRC 和 rnoh_centered_text_generated_SRC
add_library(rnoh_jverification_react_native SHARED ${rnoh_jverification_react_native_SRC} ${rnoh_jverification_react_native_generated_SRC})

# 为目标库 rnoh_centered_text 设置包含路径，这些路径会包含当前源目录和 Codegen 生成文件所在的目录
target_include_directories(rnoh_jverification_react_native PUBLIC ${CMAKE_CURRENT_SOURCE_DIR} ${rnoh_jverification_react_native_generated_dir})

# 将库 rnoh_calculator 链接到 rnoh sdk，意味着 rnoh_calculator 使用 rnoh sdk 中的功能
target_link_libraries(rnoh_jverification_react_native PUBLIC rnoh)