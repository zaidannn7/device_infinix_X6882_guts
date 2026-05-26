#
# Copyright (C) 2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff.
TARGET_DISABLE_EPPE := true
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from X6882 device
$(call inherit-product, device/infinix/X6882/device.mk)

BOARD_VENDOR := Infinix
PRODUCT_NAME := lineage_X6882
PRODUCT_DEVICE := X6882
PRODUCT_MANUFACTURER := INFINIX
PRODUCT_BRAND := Infinix
PRODUCT_MODEL := Infinix X6882

PRODUCT_GMS_CLIENTID_BASE := android-transsion
PRODUCT_SYSTEM_NAME := X6882-OP
PRODUCT_SYSTEM_DEVICE := X6882

BUILD_FINGERPRINT := Infinix/X6882-OP/Infinix-X6882:14/UP1A.231005.007/260117V1572:user/release-keys

# Time
LINEAGE_VERSION_APPEND_TIME_OF_DAY := true

