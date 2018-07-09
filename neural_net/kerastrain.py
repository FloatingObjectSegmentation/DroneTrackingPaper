import numpy as np
from keras.models import Sequential
from keras.layers import Dense, Flatten
from keras.layers import Conv3D, MaxPooling3D
from keras.optimizers import SGD

# Generate dummy data
x_train = np.random.random((100, 32, 32, 32, 1))
y_train = np.random.randint(2, size=(100, 1))
x_test = np.random.random((20, 32, 32, 32, 1))
y_test = np.random.randint(2, size=(20, 1))

model = Sequential()
model.add(Conv3D(filters=32, kernel_size=(5,5,5), strides=(2,2,2),
                 padding='same', data_format='channels_last', use_bias=True,
                 input_shape=(32,32,32,1)))
model.add(Conv3D(filters=32, kernel_size=(3,3,3),
                 padding='same', data_format='channels_last', use_bias=True))
# Valid question: Should I use stride during maxpooling?
model.add(MaxPooling3D(pool_size=(2,2,2), strides=None, padding='valid', data_format='channels_last'))
model.add(Flatten(data_format='channels_last'))
model.add(Dense(units=128,activation=None,use_bias=True))
model.add(Dense(1, activation='sigmoid'))

sgd = SGD(lr=0.01, decay=1e-6, momentum=0.9, nesterov=True)
model.compile(loss='binary_crossentropy',
              optimizer=sgd,
              metrics=['accuracy'])

model.fit(x_train, y_train, batch_size=20, epochs=5)
score = model.evaluate(x_test, y_test, batch_size=20)