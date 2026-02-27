import requests
import json
import time

PIXOO_IP = "192.168.178.33"
URL = f"http://{PIXOO_IP}/post"

def run_test():
    # 1. Schritt: Weg von der Uhr, hin zum Custom-Kanal (Index 3)
    # Ohne diesen Befehl wird deine Uhr einfach weiterlaufen!
    print("Schalte von Uhr auf Custom-Kanal um...")
    requests.post(URL, json={"Command": "Channel/SetIndex", "SelectIndex": 3})
    
    # Kurze Pause, damit das Gerät Zeit zum Umschalten hat
    time.sleep(0.5)

    # 2. Schritt: Der korrigierte Payload mit "CommandList" statt "List"
    payload = {
        "Command": "Draw/CommandList",
        "CommandList": [
            {"Command": "Draw/ClearHttpText"},
            # Wir malen ein blaues Rechteck als Hintergrund
            {
                "Command": "Draw/FillRect",
                "x": 0, "y": 0, "x1": 63, "y1": 63,
                "color": "#0000FF"
            },
            # Wir schreiben weißen Text darauf
            {
                "Command": "Draw/SendHttpText",
                "TextId": 1,
                "x": 10, "y": 25,
                "dir": 0, "font": 2,
                "TextString": "API OK!",
                "color": "#FFFFFF"
            },
            {"Command": "Draw/SendOutPicID"}
        ]
    }

    # Kompaktes JSON (wichtig für Divoom!)
    compact_data = json.dumps(payload, separators=(',', ':'))

    try:
        print("Sende Grafikdaten...")
        response = requests.post(URL, data=compact_data, timeout=5)
        print(f"Antwort vom Gerät: {response.text}")
    except Exception as e:
        print(f"Fehler: {e}")

if __name__ == "__main__":
    run_test()