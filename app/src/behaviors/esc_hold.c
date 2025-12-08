#include <zmk/behavior.h>
#include <zmk/keymap.h>
#include <zephyr/kernel.h>

static int64_t press_time = 0;

static int esc_hold_key_pressed(struct zmk_behavior_binding *binding,
                                struct zmk_behavior_binding_event event) {
    press_time = k_uptime_get();
    return ZMK_BEHAVIOR_OPAQUE;
}

static int esc_hold_key_released(struct zmk_behavior_binding *binding,
                                 struct zmk_behavior_binding_event event) {
    int64_t elapsed = k_uptime_get() - press_time;
    if (elapsed >= CONFIG_ZMK_ESC_HOLD_THRESHOLD) {
        zmk_keymap_press(ZMK_HID_USAGE_KEY_ESCAPE);
        zmk_keymap_release(ZMK_HID_USAGE_KEY_ESCAPE);
    }
    return ZMK_BEHAVIOR_OPAQUE;
}

ZMK_BEHAVIOR(esc_hold, esc_hold_key_pressed, esc_hold_key_released);
