from io import BytesIO
from PIL import Image
import base64

def generate_thumbnail_and_encode(path):
    original_image = Image.open(path)
    thumbnail = original_image.copy()
    thumbnail.thumbnail((80,80))
    thumbnail_stream = BytesIO()
    thumbnail.save(thumbnail_stream, format="JPEG")
    thumbnail_bytes = thumbnail_stream.getvalue()
    base64_encoded_thumbnail = base64.b64encode(thumbnail_bytes).decode("utf-8")
    return base64_encoded_thumbnail

# Example usage
image_path = "files/image.jpg"
thumbnail_base64 = generate_thumbnail_and_encode(image_path)

# Now you can send `thumbnail_base64` to wherever you need it
print("Base64 Encoded Thumbnail:")
print(thumbnail_base64)