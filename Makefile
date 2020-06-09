# Params
TARGET_NAME:= LearnCpp
SRCS_DIR?= src
BUILD_DIR?= .build
CXX:= g++
CPP_VERSION:=c++17

# Utils
include config.mk
CFLAGS= -Wall \
	-std=$(CPP_VERSION)			\
	$(addprefix -D,$(DEFINES)) 		\
	$(addprefix -I,$(SRCS_DIR))		\
	$(addprefix -I$(SRCS_DIR)/,$(INCLUDES))

LFLAGS = $(addprefix -l,$(LIBRARIES))

SRCS:=  $(wildcard $(SRCS_DIR)/*.cpp) \
	$(foreach dir,$(addprefix $(SRCS_DIR)/,$(INCLUDES)),$(wildcard $(dir)/*.cpp))
OBJS:= $(addprefix $(BUILD_DIR)/,$(SRCS:.cpp=.o))
TARGET:= $(BUILD_DIR)/$(TARGET_NAME)

ifeq ($(V), 1)
PREF:=
else
PREF:=@
endif

.PHONY: all

all: build
	@echo "$(TARGET_NAME) succesfully compiled. Run make start or ./$(TARGET) to start the program"

build: $(TARGET)

print_vars:
	@echo "TARGET=$(TARGET)"
	@echo "SRCS=$(SRCS)"
	@echo "OBJS=$(OBJS)"

$(TARGET): $(OBJS)
	@echo "Linking $@"
	$(PREF)$(CXX) $^ -o $@

$(BUILD_DIR)/%.o: %.cpp
	@echo "Compiling $@"
	$(PREF)mkdir -p $(@D)
	$(PREF)$(CXX) -c $^ -o $@ $(CFLAGS)

clean:
	@echo "Cleaning"
	$(PREF)rm -rf $(BUILD_DIR)

start: build
	@echo "Program start..."
	$(PREF)./$(TARGET)